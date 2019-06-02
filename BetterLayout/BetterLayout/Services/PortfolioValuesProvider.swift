//
//  PortfolioValuesProvider.swift
//  Trading
//
//  Created by Vlad Che on 3/5/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import Foundation
import SwiftDate

class PortfolioValuesProvider: ValuesProvider {
    private(set) var items: [SymbolItem]
    private(set) var historyDataInfo: [String] = []
    lazy var calculateFrom: Date = historyData.first?.date ?? Date()
    
    init(with items: [SymbolItem]) {
        self.items = items
    }
    
    var price: Float { return Portfolio.currentInfo?.amount ?? historyData.last?.price ?? 0 }
    lazy var historyData: [HistoryDataItem] = calculateHistoryData()
    
    private func calculateHistoryData() -> [HistoryDataItem] {
        let items = self.items.filter { $0.historyData.count > 0 }
        guard !items.isEmpty, !Portfolio.cashUpdates.isEmpty, !Portfolio.operationsList.items.isEmpty else { return [] }
        guard let maxItem = items.max(by: {$0.historyData.count < $1.historyData.count}) else { return [] }
        var data: [HistoryDataItem] = []
        let count = maxItem.historyData.count
        let interval = maxItem.interval
        
        let cashUpdates = Portfolio.cashUpdates
        let soldItemsCashUpdates = cashUpdates.filter { !items.map(\.code).contains($0.operation.item.code) }
        
        let operations = Portfolio.operationsList.items
        
        let startTradingDate = cashUpdates.first!.date
        
        var dataBeforeOperations: [HistoryDataItem] = []
        var dataAfterOperations: [HistoryDataItem] = []
        
        if let i = maxItem.historyData.firstIndex(where: { startTradingDate <= $0.date }) {
            dataBeforeOperations = Array(maxItem.historyData[0..<i])
            if i < count {
                dataAfterOperations = Array(maxItem.historyData[i..<count])
            }
        } else {
            dataBeforeOperations = maxItem.historyData
        }
        
        dataBeforeOperations.forEach {
            let cash = Portfolio.startCash
            data.append(HistoryDataItem(date: $0.date, price: cash, low: cash, high: cash, volume: 0, open: cash, close: cash))
            historyDataInfo.append("No operations")
        }
        
        for currentDataItem in dataAfterOperations {
            let cashUpdatesTillDate = cashUpdates.filter { currentDataItem.date >= $0.date }
            let soldItemsCashUpdatesTillDate = soldItemsCashUpdates.filter { currentDataItem.date >= $0.date }
            let cashUpdate = cashUpdatesTillDate.last!
            let cash = cashUpdate.cash
            var info = "$\(cash.maxFractions(2))"
            var (p, l, h, o, c) = (cash, cash, cash, cash, cash)
            defer {
                historyDataInfo.append(info)
                data.append(HistoryDataItem(date: currentDataItem.date, price: p, low: l, high: h, volume: 0, open: o, close: c))
            }
            
            func calculate(for item: SymbolItem, data: HistoryDataItem) {
                let itemOperations = operations.filter { $0.item.code == item.code && currentDataItem.date >= $0.date }
                guard !itemOperations.isEmpty else { return }
                let amount = itemOperations.map(\.amount).reduce(0, +)
                p += data.price * amount
                l += data.low * amount
                h += data.high * amount
                o += data.open * amount
                c += data.close * amount
                let sign = amount >= 0 ? "+" : "-"
                info += " \(sign) \(item.code) \(abs(amount).maxFractions(2)) x \(data.price.maxFractions(2))"
            }
            
            calculate(for: maxItem, data: currentDataItem)
            
            let otherItems = items.filter { $0.code != maxItem.code }
            for otherItem in otherItems {
                let historyData = maxItem.adjusted(otherItem.historyData)
                if let otherDataItem = historyData.last(where: { currentDataItem.date >= $0.date }) {
                    calculate(for: otherItem, data: otherDataItem)
                }
            }
            
            for operation in soldItemsCashUpdatesTillDate.map(\.operation) {
                p += operation.price * operation.amount
                l += operation.price * operation.amount
                h += operation.price * operation.amount
                o += operation.price * operation.amount
                c += operation.price * operation.amount
                let plus = operation.amount >= 0 ? "+" : "-"
                info += " \(plus) sold \(operation.item.code) \(abs(operation.amount).maxFractions(2)) x \(operation.price.maxFractions(2))"
            }
        }
        
        return data
    }
}

extension SymbolItem {
    var interval: TimeInterval {
        guard let first = historyData.first?.date, let second = historyData[safe: 1]?.date else { return 0 }
        return TimeInterval(first.getInterval(toDate: second, component: .second))
    }
}

extension SymbolItem {
    var portfolioPrice: Float { return price * Portfolio.amount(of: MarketItem.with(code)) }
    var portfolioLow: Float { return low * Portfolio.amount(of: MarketItem.with(code)) }
    var portfolioHigh: Float { return high * Portfolio.amount(of: MarketItem.with(code)) }
    var portfolioOpen: Float { return open * Portfolio.amount(of: MarketItem.with(code)) }
    var portfolioClose: Float { return close * Portfolio.amount(of: MarketItem.with(code)) }
}

extension PortfolioValuesProvider {
    var currentDataItem: HistoryDataItem {
        let price = items.reduce(Float(0)) { $0 + $1.portfolioPrice} + Portfolio.availableCash
        let low = items.reduce(0) { $0 + $1.portfolioLow } + Portfolio.availableCash
        let high = items.reduce(0) { $0 + $1.portfolioHigh } + Portfolio.availableCash
        let open = items.reduce(0) { $0 + $1.portfolioOpen } + Portfolio.availableCash
        let close = items.reduce(0) { $0 + $1.portfolioClose } + Portfolio.availableCash
        let volume = items.reduce(0) { $0 + $1.volume }
        return HistoryDataItem(date: Date(), price: price, low: low, high: high, volume: volume, open: open, close: close)
    }
}

