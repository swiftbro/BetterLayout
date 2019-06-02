//
//  Symbol.swift
//  Trading
//
//  Created by Vlad Che on 1/23/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import Foundation
import SwiftDate
import PromiseKit

struct SymbolResponse: Codable {
    let metaData: MetaData
    let timeSeries: [[String: TimeSerie]]
    
    init(from decoder: Decoder) throws {
        timeSeries = try decoder.decode(Symbol.Key.series)
        metaData = try decoder.decode(Symbol.Key.meta)
        print("\(metaData.symbol): \(timeSeries.count) values")
    }
}

struct Symbol: Codable {
    let metaData: MetaData
    let timeSeries: [TimeSerie]
    let type: SymbolsType
   
    func with(type: SymbolsType) -> Symbol {
        return Symbol(metaData: metaData, timeSeries: timeSeries, type: type)
    }
    
    init(with response: SymbolResponse) {
        metaData = response.metaData
        timeSeries = response.timeSeries.reversed().map {
            var timeSerie = $0.values.first!
            timeSerie.date = $0.keys.first!.date!
            return timeSerie
        }
        self.type = .cryptocurrensies
    }
    
    init(metaData: MetaData, timeSeries: [TimeSerie], type: SymbolsType) {
        self.metaData = metaData
        self.timeSeries = timeSeries
        self.type = type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyKey.self)
        metaData = try container.decode(Key.meta)
        timeSeries = try container.decodeKeyedElements(Key.series)
        type = .cryptocurrensies
    }

}

struct TimeSerie: Codable {
    let open: String
    let high: String
    let low: String
    let close: String
    let volume: String?
    var date: Date
    
    init(from decoder: Decoder) throws {
        let keyed = try? decoder.currentKey().date.orThrow("TimeSerie `date` has wrong format")
        date = keyed ?? Date()
        open = try decoder.decode(Key.open)
        high = try decoder.decode(Key.high)
        low = try decoder.decode(Key.low)
        close = try decoder.decode(Key.close)
        volume = try? decoder.decode(Key.volume)
    }
}

struct MetaData: Codable {
    let info: String
    let symbol: String
    let lastRefreshed: String
    let timeZone: String
    
    init(from decoder: Decoder) throws {
        info = try decoder.decode(Key.info)
        let fromSymbol: String? = try? decoder.decode(Key.fromSymbol)
        let symbol: String? = try? decoder.decode(Key.symbol)
        self.symbol = try fromSymbol ?? symbol ?? decoder.decode(Key.code)
        lastRefreshed = try decoder.decode(Key.lastRefreshed)
        timeZone = try decoder.decode(Key.timeZone)
    }
}

extension Symbol {
    func fromDate(for period: HistoryPeriod) -> Date {
        guard let last = timeSeries.last else { return Date() }
        let lastDate = last.date.dateAtStartOf(.day)
        switch period {
        case .day: return last.date.dateAtStartOf(.day)
        case .week:
            if lastDate.weekday == 2 {
                return lastDate.dateAt(.prevWeek)
            } else {
                return lastDate.dateAt(.nextWeekday(.monday)).dateAt(.prevWeek)
            }
        case .month: return lastDate - 1.months
        case .quarter: return lastDate - 3.months
        case .year: return lastDate - 1.years
        case .all: return lastDate - 9999.years
        }
    }
    
    func filter(from date: Date) -> Symbol {
        var filtered = Symbol(metaData: metaData, timeSeries: timeSeries.filter { $0.date >= date }, type: type)
        if filtered.timeSeries.count < 2, let
            last = timeSeries.last,
            let before = timeSeries[safe: timeSeries.count - 2] {
            filtered = Symbol(metaData: metaData, timeSeries: [before, last], type: type)
        }
        return filtered
    }
}

extension Promise where T == Symbol {
    func filter(for period: HistoryPeriod) -> Promise<Symbol> {
        if period == .all { return self }
        return map {
            let date = $0.fromDate(for: period)
            return $0.filter(from: date)
        }
    }
}
