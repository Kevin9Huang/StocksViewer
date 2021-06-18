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
        static let assetsEndpoint = "https://min-api.cryptocompare.com/data/top/totaltoptiervolfull?limit=50&tsym=USD&ascending=false"
    }
    
    //MARK: - Public Method
    public func getAllCryptoData(completion: @escaping (Result<[CryptoModel], Error>) -> Void) {
        guard let url = URL(string: Constants.assetsEndpoint) else {
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
}
