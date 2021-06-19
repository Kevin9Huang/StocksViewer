//
//  StocksViewerViewModel.swift
//  StocksViewer
//
//  Created by Kevin Huang on 17/06/21.
//

import Foundation

protocol StocksViewerViewModelDelegate {
    func reloadTableWith(models: [CryptoModel]?)
    func presentNewsModelVC(with vm: NewsViewModel)
    func showLoadingIndicator(isShow: Bool)
    func showAlertWith(message: String)
    func stopRefreshControl()
}

class StocksViewerViewModel {
    //public
    public var delegate : StocksViewerViewModelDelegate?
    
    //private
    private var models : [CryptoModel]?
    private var isShowFirstLoading = true
    private var isSocketConnected = false
    private var isAlreadySetSocketSubscription = false
    private var modelIndexDict = [String:Int]()
    
    //MARK: - Public Method
    public func onViewDidLoad() {
        fetchCoinsData(isFromRefresh: false)
        estabalishWebSocketConnection()
    }
    
    public func pulledToRefresh() {
        fetchCoinsData(isFromRefresh: true)
    }
    
    public func cellTapped(at index: Int) {
        guard let models = models,
            index < models.count,
            let internal_name = models[index].internal_name else {
            print("Failed to get model...")
            return
        }
        fetchCoinNewsWith(name: internal_name)
    }
    
    public func onNetworkErrorReloadButtonTapped() {
        fetchCoinsData(isFromRefresh: false)
        estabalishWebSocketConnection()
    }
    
    public func onDeinit() {
        WebSocketeManager.shared.stopConnecting()
    }
    
    //MARK: - Private Method
    private func fetchCoinsData(isFromRefresh: Bool) {
        guard let delegate = self.delegate else {
            return
        }
        if isShowFirstLoading {
            delegate.showLoadingIndicator(isShow: true)
        }
        
        APICaller.shared.getCryptoCoinsData {[weak self] result in
            switch result {
            case .success(let models):
                guard let strongSelf = self else {
                    return
                }
                strongSelf.models = models
                DispatchQueue.main.async {
                    delegate.reloadTableWith(models: models)
                }
                if !strongSelf.isAlreadySetSocketSubscription {
                    strongSelf.setCoinSubsciption()
                }
            case .failure(let error):
                print("Failed to get data from api: \(error)")
                delegate.showAlertWith(message: "Failed to fetch coins")
            }
            
            delegate.showLoadingIndicator(isShow: false)
            delegate.stopRefreshControl()
        }
    }
    
    private func fetchCoinNewsWith(name: String) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.showLoadingIndicator(isShow: true)
        APICaller.shared.getCyrptoNews(with: name, completion: {result in
            switch result {
            case .success(let newsModel):
                DispatchQueue.main.async {
                    let newsVM = NewsViewModel(newsModel: newsModel)
                    delegate.presentNewsModelVC(with: newsVM)
                }
            case .failure(let error):
                print("Failed to get data from api: \(error)")
                delegate.showAlertWith(message: "Failed to fetch news")
            }
            DispatchQueue.main.async {
                delegate.showLoadingIndicator(isShow: false)
                delegate.stopRefreshControl()
            }
        })
    }
    
    private func estabalishWebSocketConnection() {
        WebSocketeManager.shared.stopConnecting()
        WebSocketeManager.shared.startConnecting()
        WebSocketeManager.shared.delegate = self
    }
    
    private func setCoinSubsciption() {
        guard let models = models,
              !models.isEmpty,
              isSocketConnected else {
            return
        }
        
        WebSocketeManager.shared.subscribeTo(models: models)
        isAlreadySetSocketSubscription = true
    }
    
    private func createModelIndexDict() {
        guard let models = models,
              !models.isEmpty else {
            return
        }
        modelIndexDict = [String:Int]()
        for (index, model) in models.enumerated() {
            guard let coinName = model.internal_name else {
                return
            }
            modelIndexDict[coinName] = index
        }
    }
    
    private func updateModelPriceWith(dict: [String:Any]) {
        guard let models = models,
              !models.isEmpty,
              let coinName = dict["FROMSYMBOL"] as? String,
              let coinPrice = dict["PRICE"] as? Double else {
            return
        }
        if modelIndexDict.isEmpty {
            createModelIndexDict()
        }
        if let index = modelIndexDict[coinName] {
            models[index].price_usd = "$ \(coinPrice)"
        }
        delegate?.reloadTableWith(models: models)
    }
}

extension StocksViewerViewModel: WebSocketMessageDelegate {
    func onConnected() {
        isSocketConnected = true
        setCoinSubsciption()
    }
    func receiveMessage(text: String) {
        if let data = text.data(using: .utf8) {
            do {
                let dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                guard let messageDict = dictonary,
                      let type = messageDict["TYPE"] as? String else {
                    return
                }
                if type == "2" { //Ticker message
                    updateModelPriceWith(dict: messageDict)
                } else if type == "3" { //All subscribe loaded
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.setCoinSubsciption()
                    }
                    
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

