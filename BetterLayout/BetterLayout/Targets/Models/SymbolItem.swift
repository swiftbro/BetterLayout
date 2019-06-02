//
//  SymbolItem.swift
//  Trading
//
//  Created by Vlad Che on 2/27/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import Foundation

struct SymbolItem: ValuesProvider {
    let code: String
    let type: SymbolsType
    let historyData: [HistoryDataItem]
    lazy var calculateFrom: Date = historyData.first?.date ?? Date()
    
    init(name: String, type: SymbolsType, historyData: [HistoryDataItem]) {
        self.code = name
        self.type = type
        self.historyData = historyData
    }
    
    func appending(_ info: SymbolInfo) -> SymbolItem {
        var data = historyData
        data.append(HistoryDataItem.with(info))
        return SymbolItem(name: code, type: type, historyData: data)
    }
}

extension SymbolItem: Equatable {
    public static func == (lhs: SymbolItem, rhs: SymbolItem) -> Bool {
        return lhs.code == rhs.code && lhs.type == rhs.type
    }
}

struct HistoryDataItem {
    let date: Date
    let price: Float
    let low: Float
    let high: Float
    let volume: Float
    let open: Float
    let close: Float
}

enum MarketState {
    case up, down
}

extension SymbolItem {
    
    init(with symbol: Symbol) {
        self.init(with: symbol, sort: false)
    }
    
    init(with symbol: Symbol, sort: Bool) {
        code = symbol.metaData.symbol
        type = symbol.type
        var series = symbol.timeSeries
        if sort { series.sort(by: { $0.date < $1.date })}
        historyData = series.compactMap {
            guard let price = $0.price,
                let low = Float($0.low),
                let high = Float($0.high),
                let volume = Float($0.volume ?? "0"),
                let open = Float($0.open),
                let close = Float($0.close)
                else {return nil}
            return HistoryDataItem(date: $0.date, price: price, low: low, high: high, volume: volume, open: open, close: close)
        }
    }
}

extension TimeSerie {
    var price: Float? {
        guard let close = Float(close) else {return nil}
        return close
    }
}

struct MarketItem: Codable {
    let name: String
    let code: String
    let info: String
    let type: SymbolsType
}

extension MarketItem: Equatable {
    
    static func with(_ code: String) -> MarketItem {
        return MarketItem(name: code, code: code, info: "", type: .stocks)
    }
    
    static func ==(lhs: MarketItem, rhs: MarketItem) -> Bool {
        return lhs.code == rhs.code && lhs.type == rhs.type
    }
}
