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
    
    //MARK: - Public Method
    public func onViewDidLoad() {
        fetchCoinsData(isFromRefresh: false)
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
    
    //MARK: - Private Method
    private func fetchCoinsData(isFromRefresh: Bool) {
        guard let delegate = self.delegate else {
            return
        }
        if isShowFirstLoading {
            delegate.showLoadingIndicator(isShow: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
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
        
    }
    
    private func fetchCoinNewsWith(name: String) {
        APICaller.shared.getCyrptoNews(with: name, completion: {[weak self] result in
            switch result {
            case .success(let newsModel):
                DispatchQueue.main.async {
                    guard let delegate = self?.delegate else {
                        return
                    }
                    let newsVM = NewsViewModel(newsModel: newsModel)
                    delegate.presentNewsModelVC(with: newsVM)
                }
            case .failure(let error):
                print("Failed to get data from api: \(error)")
            }
        })
    }
}

