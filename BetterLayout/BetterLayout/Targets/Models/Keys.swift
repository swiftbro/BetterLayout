//
//  SymbolKeys.swift
//  Trading
//
//  Created by Vlad Che on 3/3/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import Foundation

extension Symbol {
    enum Key {
        static let meta = "meta"
        static let series = "series"
    }
}

extension SymbolInfo {
    enum Key {
        static let symbol = "symbol"
        static let code = "from_currency code"
        static let name = "from_currency name"
        
        static let rate = "rate"
        static let date = "refreshed"
        
        static let price = "price"
        static let open = "open"
        static let high = "high"
        static let low = "low"
        static let volume = "volume"
        static let change = "change"
        static let percent = "percent"
    }
}

extension MetaData {
    enum Key {
        static let info = "info"
        static let symbol = "symbol"
        static let fromSymbol = "from symbol"
        static let code = "currency code"
        static let name = "currency name"
        static let marketCode = "market code"
        static let marketName = "market name"
        static let lastRefreshed = "last"
        static let timeZone = "zone"
    }
}

extension TimeSerie {
    enum Key {
        static let open = "open"
        static let high = "high"
        static let low = "low"
        static let close = "close"
        static let volume = "volume"
    }
}

extension SearchMatch {
    enum Key {
        static let symbol = "symbol"
        static let name = "name"
        static let type = "type"
        static let score = "score"
        static let region = "region"
        static let marketOpen = "marketOpen"
        static let marketClose = "marketClose"
        static let zone = "zone"
        static let currency = "currency"
    }
}
