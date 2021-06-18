//
//  StocksViewerViewModel.swift
//  StocksViewer
//
//  Created by Kevin Huang on 17/06/21.
//

import Foundation

protocol StocksViewerViewModelDelegate {
    func reloadTableWith(models: [CryptoModel]?)
    func presentNewsModelWith(news: [CryptoNewsModel])
}

class StocksViewerViewModel {
    //public
    public var delegate : StocksViewerViewModelDelegate?
    
    //private
    private var models : [CryptoModel]?
    
    //MARK: - Public Method
    public func onViewDidLoad() {
        guard let delegate = delegate else {
            return
        }
        fetchCoinsData()
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
    private func fetchCoinsData() {
        APICaller.shared.getAllCryptoData {[weak self] result in
            switch result {
            case .success(let models):
                DispatchQueue.main.async {
                    guard let delegate = self?.delegate else {
                        return
                    }
                    delegate.reloadTableWith(models: models)
                }
            case .failure(let error):
                print("Failed to get data from api: \(error)")
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
                    delegate.presentNewsModelWith(news: newsModel)
                }
            case .failure(let error):
                print("Failed to get data from api: \(error)")
            }
        })
    }
}

