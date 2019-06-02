//
//  InfoService.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import Foundation
import Moya
import PromiseKit

class InfoService {
    static let shared = InfoService()
    private let provider = MoyaProvider<SymbolsTarget>.default
    private var lastRequestToken = CancelToken()
    private var cache: [String: ResponseCache] = [:]
    
    func getInfo(for symbol: String, type: SymbolsType, cancelPrevious: Bool = false) -> Promise<SymbolInfo> {
        var response: Promise<Moya.Response>
        if let cached = cache[symbol], abs(cached.date.timeIntervalSinceNow) < 5.minutes.timeInterval {
            response = Promise.value(cached.response)
        } else {
            cache[symbol] = nil
            if cancelPrevious {
                lastRequestToken.cancel()
                response = provider.request(.info(symbol, type), token: &lastRequestToken)
            } else {
                response = provider.request(.info(symbol, type))
            }
            response = response.get { self.cache[symbol] = ResponseCache($0) }
        }
        return response
            .filterSuccessfulStatusCodes()
            .decode(SymbolInfoResponse.self)
            .map { $0.info.with(type: type) }
            .recover { error -> Promise<SymbolInfo> in
                self.cache[symbol] = nil
                throw error
            }
    }
}
