//
//  StocksViewerViewModel.swift
//  StocksViewer
//
//  Created by Kevin Huang on 17/06/21.
//

import Foundation

protocol StocksViewerViewModelDelegate {
    func reloadTableWith(models: [CryptoModel]?)
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
        fetchData()
    }
    
    //MARK: - Private Method
    private func fetchData() {
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
}

