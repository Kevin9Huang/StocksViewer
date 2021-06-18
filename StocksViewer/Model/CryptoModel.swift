//
//  CryptoModel.swift
//  StocksViewer
//
//  Created by Kevin Huang on 17/06/21.
//

import Foundation

class CryptoModel {
    public let asset_id : String
    public let shortName : String
    public let fullName: String?
    public let price_usd: String?
    public let change24Hour: String?
    public let changePct24Hour: String?
    public let internal_name: String?
    
    init(asset_id: String, shortName: String, fullName: String, price_usd: String, change24Hour: String, changePct24Hour: String, internal_name: String) {
        self.asset_id = asset_id
        self.shortName = shortName
        self.fullName = fullName
        self.price_usd = price_usd
        self.changePct24Hour = changePct24Hour
        self.change24Hour = change24Hour
        self.internal_name = internal_name
    }
    
    static public func createCoin(with dict: [String: Any]) -> CryptoModel? {
        guard let coinInfo = dict["CoinInfo"] as? [String: Any],
              let id = coinInfo["Id"] as? String,
              let name = coinInfo["Name"] as? String,
              let fullName = coinInfo["FullName"] as? String,
              
              let display = dict["DISPLAY"] as? [String: Any],
              let inUSD = display["USD"] as? [String: Any],
              let price = inUSD["PRICE"] as? String,
              let change24Hour = inUSD["CHANGE24HOUR"] as? String,
              let changePct24Hour = inUSD["CHANGEPCT24HOUR"] as? String,
              let internal_name = coinInfo["Internal"] as? String else {
            return nil
        }
        return CryptoModel(asset_id: id,
                           shortName: name,
                           fullName: fullName,
                           price_usd: price,
                           change24Hour: change24Hour,
                           changePct24Hour: changePct24Hour,
                           internal_name: internal_name)
    }
}
