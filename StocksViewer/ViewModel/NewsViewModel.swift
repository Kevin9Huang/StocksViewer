//
//  NewsViewModel.swift
//  StocksViewer
//
//  Created by Kevin Huang on 18/06/21.
//

import Foundation

import Foundation

protocol NewsViewModelDelegate {
    func reloadTableWith(newsModelArray: [CryptoNewsModel]?)
}

class NewsViewModel {
    
    //public
    public var delegate : NewsViewModelDelegate?
    
    //private
    private var newsModel : [CryptoNewsModel]
    
    init(newsModel: [CryptoNewsModel]) {
        self.newsModel = newsModel
    }
    
    //MARK: - Public Method
    public func onViewDidLoad() {
        if delegate != nil {
            delegate?.reloadTableWith(newsModelArray: newsModel)
        }
    }
}

