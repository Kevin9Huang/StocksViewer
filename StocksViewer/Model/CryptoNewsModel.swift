//
//  CryptoNewsModel.swift
//  StocksViewer
//
//  Created by Kevin Huang on 18/06/21.
//

import Foundation

class CryptoNewsModel {
    var title: String
    var source_info_name: String
    var body: String
    
    init(title: String, source_info_name: String, body: String) {
        self.title = title
        self.source_info_name = source_info_name
        self.body = body
    }
    
    static public func createNewsModelWith(dict: [String: Any]) -> CryptoNewsModel? {
        guard let title = dict["title"] as? String,
              let body = dict["body"] as? String,
              let source_info = dict["source_info"] as? [String : Any],
              let source_name = source_info["name"] as? String else {
            return nil
        }
        
        return CryptoNewsModel(title: title,
                               source_info_name: source_name,
                               body: body)
    }
}
