//
//  ValuesProvider.swift
//  Trading
//
//  Created by Vlad Che on 3/7/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import Foundation
import Charts

protocol ValuesProvider {
    var calculateFrom: Date { get set }
    var historyData: [HistoryDataItem] { get }
    var price: Float { get }
    var low: Float { get }
    var high: Float { get }
    var volume: Float { get }
    var open: Float { get }
    var close: Float { get }
    var changeValue: Float { get }
    var changePercent: Float { get }
    var state: MarketState { get }
}

extension ValuesProvider {
    var calculateFrom: Date {
        get { return historyData.first?.date ?? Date() }
        set { fatalError("override calculateFrom to set") }
    }
    var price: Float { return historyData.last?.price ?? 0 }
    var low: Float { return historyData.map(\.low).reduce(.infinity, min) }
    var high: Float { return historyData.map(\.high).reduce(0, max) }
    var open: Float { return historyData.last?.open ?? 0 }
    var close: Float { return historyData.last?.close ?? 0 }
    var volume: Float { return historyData.last?.volume ?? 0 }
    var startPrice: Float {
        return historyData.first(where: { $0.date >= calculateFrom })?.price ?? price
    }
    var changeValue: Float {
        return price >= startPrice ? price - startPrice : startPrice - price
    }
    var changePercent: Float {
        return changeValue / startPrice * 100
    }
    var state: MarketState {
        return price >= startPrice ? .up : .down
    }
    
    public func adjusted(_ historyData: [HistoryDataItem]) -> [HistoryDataItem] {
        guard !historyData.isEmpty else { return [] }
        var data: [HistoryDataItem] = []
        for item in self.historyData {
            let adjusted = historyData.last(where: { item.date >= $0.date }) ?? historyData.first!
            data.append(HistoryDataItem(date: item.date, price: adjusted.price,
                                        low: adjusted.low, high: adjusted.high,
                                        volume: adjusted.volume,
                                        open: adjusted.open, close: adjusted.close))
        }
        return data
    }
}

class ChartDataItem {
    let previous: HistoryDataItem?
    let current: HistoryDataItem
    
    init(with current: HistoryDataItem, previous: HistoryDataItem?) {
        self.previous = previous
        self.current = current
    }
}

extension ChartDataItem: ValuesProvider {
    var low: Float { return current.low }
    var high: Float { return current.high }
    var historyData: [HistoryDataItem] {
        return [previous, current].compact()
    }
}
