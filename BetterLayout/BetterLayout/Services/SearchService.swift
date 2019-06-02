//
//  SearchService.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import Foundation
import Moya
import PromiseKit

class SearchService {
    private let provider = MoyaProvider<SymbolsTarget>.default
    private var lastRequestToken = CancelToken()
    private let queue: DispatchQueue = DispatchQueue(label: "SearchService.CSV.Queue")
    
    func searchStocks(_ string: String) -> Guarantee<[SearchMatch]> {
        lastRequestToken.cancel()
        guard !string.isEmpty else { return Guarantee.value([]) }
        let promise = provider.request(.search(string), token: &lastRequestToken)
            .filterSuccessfulStatusCodes()
            .decode(SearchResponse.self)
            .map(\.bestMatches)
            .onErrorJustReturn([])
        return promise
    }
    
    func searchCryptos(_ text: String) -> Promise<[Currency]> {
        return queue.async(.promise) {
            let cryptos = try CSV(name: "crypto.csv")
            return cryptos.findOccurences(of: text).map { Currency(name: $0.name, code: $0.code, type: .cryptocurrensies) }
        }
    }
    
    func searchForex(_ text: String) -> Promise<[Currency]> {
        return queue.async(.promise) {
            let cryptos = try CSV(name: "forex.csv")
            return cryptos.findOccurences(of: text).map { Currency(name: $0.name, code: $0.code, type: .forex) }
        }
    }
}

struct Currency {
    let name: String
    let code: String
    let type: SymbolsType
}
