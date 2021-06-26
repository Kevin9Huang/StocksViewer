//
//  WebSocketManager.swift
//  StocksViewer
//
//  Created by Kevin Huang on 18/06/21.
//

import Foundation
import Starscream

struct SubscribeMessage: Codable {
    
    var action : String
    var subs : [String]
    
    init() {
        self.action = ""
        self.subs = []
    }
}

protocol WebSocketMessageDelegate {
    func receiveMessage(text: String)
    func onConnected()
}

final class WebSocketManager {
    static let shared = WebSocketManager()
    
    public var delegate: WebSocketMessageDelegate?
    
    private var socket : WebSocket
    private(set) var isConnected: Bool = false
    
    private struct Constants {
        static let crytoWebSocketBaseUrl = "wss://streamer.cryptocompare.com/v2"
        static let webSocketAPIKey = "<<YOUR_API_KEY_HERE>>"
    }
    
    init() {
        let url = "\(Constants.crytoWebSocketBaseUrl)?api_key=\(Constants.webSocketAPIKey)"
        var request = URLRequest(url: URL(string: url)!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
    }
    
    //MARK: - Public Method
    public func startConnecting() {
        socket.delegate = self
        socket.connect()
    }
    
    public func stopConnecting() {
        socket.disconnect()
    }
    
    public func subscribeTo(models: [CryptoModel]) {
        guard !models.isEmpty else {
            return
        }
        var subscribeMes = SubscribeMessage()
        subscribeMes.action = "SubAdd"
        for cryptoModel in models {
            let ticker = "2~" + cryptoModel.lastMarket + "~" + cryptoModel.shortName + "~USD"
            subscribeMes.subs.append(ticker)
        }
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(subscribeMes)
        socket.write(data: jsonData)
    }
}

extension WebSocketManager: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
            
            guard let delegate = delegate else {
                return
            }
            delegate.onConnected()
            
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
            guard let delegate = delegate else {
                return
            }
            delegate.receiveMessage(text: string)
        case .binary(let data):
            print("Received data: \(data.count)")
            break
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
        }
    }
    
    
}
