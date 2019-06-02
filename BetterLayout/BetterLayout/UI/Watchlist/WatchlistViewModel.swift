//
//  WatchlistViewModel.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import Foundation
import PromiseKit

class WatchlistViewModel {
    
    let list: Watchlist<MarketItem>
    
    
    func getSymbols(_ addSymbol: @escaping (SymbolItem) -> Void) -> Promise<[SymbolItem]> {
        cancelTokens.forEach { $0.cancel() }
        cancelTokens = []
        let waitAtLeast = after(seconds: 1)
        let promises = list.items.map { item -> Promise<SymbolItem> in
            var cancelToken = CancelToken()
            self.cancelTokens.append(cancelToken)
            return self.service.get(item.code, type: item.type, token: &cancelToken)
                .map(SymbolItem.init)
                .then { self.appendInfo(for: item, symbol: $0) }
                .get(addSymbol)
                .then { item in waitAtLeast.map { item } }
        }
        return when(fulfilled: promises.makeIterator(), concurrently: 3)
    }
    
    // MARK: Init
    
    init(with service: SymbolsProvider, list: Watchlist<MarketItem>) {
        self.service = service
        self.list = list
    }
    
    // MARK: Private
    private let service: SymbolsProvider
    private let infoService = InfoService.shared
    private var cancelTokens: [CancelToken] = []
    
    private func appendInfo(for item: MarketItem, symbol: SymbolItem) -> Promise<SymbolItem> {
        return self.infoService.getInfo(for: item.code, type: item.type)
            .map { info in return symbol.appending(info) }
    }

}

protocol SymbolsProvider {
    func get(_ symbol: String, type: SymbolsType, token: inout CancelToken) -> Promise<Symbol>
}

extension HistoryDataItem {
    static func with(_ info: SymbolInfo) -> HistoryDataItem {
        return HistoryDataItem(date: info.date, price: info.price, low: info.low, high: info.high,
                               volume: info.volume, open: info.open, close: info.close)
    }
}
