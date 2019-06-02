//
//  SearchViewModel.swift
//  Trading
//
//  Created by Vlad Che on 2/26/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit
import PromiseKit

class SearchViewModel {
    let list: Watchlist<MarketItem>
    let suggestions: Watchlist<MarketItem>
    
    init(with list: Watchlist<MarketItem>, suggestions: Watchlist<MarketItem>) {
        self.list = list
        self.suggestions = suggestions
    }
    
    private let service = SearchService()
    
    func searchStocks(_ text: String) -> Promise<[MarketItem]> {
        return service.searchStocks(text).mapValues(self.marketItem)
    }
    
    func searchCryptos(_ text: String) -> Promise<[MarketItem]> {
        return service.searchCryptos(text).mapValues(self.marketItem)
    }
    
    func searchForex(_ text: String) -> Promise<[MarketItem]> {
        return service.searchForex(text).mapValues(self.marketItem)
    }
    
    private func marketItem(for match: SearchMatch) -> MarketItem {
        return MarketItem(name: match.name, code: match.symbol, info: match.symbol, type: .stocks)
    }
    
    private func marketItem(for match: Currency) -> MarketItem {
        return MarketItem(name: match.name, code: match.code, info: match.code, type: match.type)
    }
}
