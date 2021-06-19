//
//  StocksViewerViewModel.swift
//  StocksViewer
//
//  Created by Kevin Huang on 17/06/21.
//

import Foundation

protocol StocksViewerViewModelDelegate {
    func reloadTableWith(models: [CryptoModel]?, isStopRefresh: Bool)
    func presentNewsModelVC(with vm: NewsViewModel)
    func showLoadingIndicator(isShow: Bool)
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
                    delegate.reloadTableWith(models: models, isStopRefresh: isFromRefresh)
                }
                if !strongSelf.isAlreadySetSocketSubscription {
                    strongSelf.setCoinSubsciption()
                }
            case .failure(let error):
                print("Failed to get data from api: \(error)")
            }
            
            guard let strongSelf = self else {
                return
            }
            if strongSelf.isShowFirstLoading {
                strongSelf.isShowFirstLoading = false
                DispatchQueue.main.async {
                    delegate.showLoadingIndicator(isShow: false)
                }
            }
        }
    }
    
    private func fetchCoinNewsWith(name: String) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.showLoadingIndicator(isShow: true)
        APICaller.shared.getCyrptoNews(with: name, completion: {result in
            delegate.showLoadingIndicator(isShow: false)
            switch result {
            case .success(let newsModel):
                DispatchQueue.main.async {
                    let newsVM = NewsViewModel(newsModel: newsModel)
                    delegate.presentNewsModelVC(with: newsVM)
                }
            case .failure(let error):
                print("Failed to get data from api: \(error)")
            }
        })
    }
    
    private func estabalishWebSocketConnection() {
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
        delegate?.reloadTableWith(models: models, isStopRefresh: false)
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
                if type == "2" {
                    updateModelPriceWith(dict: messageDict)
                } else if type == "3" {
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

