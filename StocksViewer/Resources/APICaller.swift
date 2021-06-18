//
//  APICaller.swift
//  StocksViewer
//
//  Created by Kevin Huang on 17/06/21.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private struct Constants {
        static let endPointFetchCrpytoCoins = "https://min-api.cryptocompare.com/data/top/totaltoptiervolfull?limit=50&tsym=USD&ascending=false"
        static let endPointFetchNewsForCoins = "https://min-api.cryptocompare.com/data/v2/news/?lang=EN&excludeCategories=Sponsored"
    }
    
    //MARK: - Public Method
    public func getCryptoCoinsData(completion: @escaping (Result<[CryptoModel], Error>) -> Void) {
        guard let url = URL(string: Constants.endPointFetchCrpytoCoins) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { response, _, error in
            guard let response = response,
                  error == nil else {
                print("Failed to fetch data")
                return
            }
                        
            do {
                // Decode from api response
                let json = try JSONSerialization.jsonObject(with: response, options: [])
                guard let responseDict = json as? [String: Any],
                      let coinArrayDict = responseDict["Data"] as? [[String: Any]] else {
                    return
                }
                
                var cryptos = [CryptoModel]()
                for coinDict in coinArrayDict {
                    if let coinModel = CryptoModel.createCoin(with: coinDict) {
                        cryptos.append(coinModel)
                    }
                }

                completion(.success(cryptos))
            }
            catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    public func getCyrptoNews(with category:String,completion: @escaping (Result<[CryptoNewsModel], Error>) -> Void) {
        let endPointNewsForCoin = Constants.endPointFetchNewsForCoins + "&categories=\(category)"
        guard let url = URL(string: endPointNewsForCoin) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { response, _, error in
            guard let response = response,
                  error == nil else {
                print("Failed to fetch data")
                return
            }
                        
            do {
                // Decode from api response
                let json = try JSONSerialization.jsonObject(with: response, options: [])
                guard let responseDict = json as? [String: Any],
                      let cryptoNewsDict = responseDict["Data"] as? [[String: Any]] else {
                    return
                }
                
                var cryptoNews = [CryptoNewsModel]()
                for newsDict in cryptoNewsDict {
                    if let newsModel = CryptoNewsModel.createNewsModelWith(dict: newsDict) {
                        cryptoNews.append(newsModel)
                    }
                }

                completion(.success(cryptoNews))
            }
            catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
