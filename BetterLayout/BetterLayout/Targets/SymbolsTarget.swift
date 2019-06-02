//
//  SymbolsTarget.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import Foundation
import Moya

enum SymbolsTarget {
    case intraday(_ symbol: String, _ type: SymbolsType, _ interval: Interval, _ size: OutputSize)
    case daily(_ symbol: String, _ type: SymbolsType, _ output: OutputSize)
    case monthly(_ symbol: String, _ type: SymbolsType)
    case search(_ string: String)
    case info(_ symbol: String, _ type: SymbolsType)
}

extension SymbolsTarget: AlphaVantageTarget {
    
    var task: Moya.Task {
        switch self {
        case .intraday: return .queryParams(intraday())
        case .daily: return .queryParams(daily())
        case .monthly: return .queryParams(monthly())
        case .search: return .queryParams(search())
        case .info: return .queryParams(info())
        }
    }
    
    var sampleData: Data {
        switch self {
        case .intraday: return stub("intraday")
        case .daily: return stub("daily")
        case .monthly: return stub("weekly")
        case .search: return stub("search")
        case .info: return Data()
        }
    }
}

extension SymbolsTarget {
    fileprivate func intraday() -> [String: Any] {
        guard case let .intraday(symbol, _, interval, size) = self else { return [:] }
        var params = ["function": function,
                      "interval": interval.string,
                      "apikey": apiKey,
                      "outputsize": size.string]
        update(&params, symbol: symbol)
        return params
    }
    
    fileprivate func daily() -> [String: Any] {
        guard case let .daily(symbol, _, size) = self else { return [:] }
        var params = ["function": function, "apikey": apiKey]
        update(&params, symbol: symbol)
        if type != .cryptocurrensies {
            params["outputsize"] = size.string
        }
        return params
    }
    
    fileprivate func monthly() -> [String: Any] {
        guard case let .monthly(symbol, _) = self else { return [:] }
        var params = ["function": function, "apikey": apiKey]
        update(&params, symbol: symbol)
        return params
    }
    
    fileprivate func search() -> [String: Any] {
        guard case let .search(string) = self else { return [:] }
        return ["function": function, "keywords": string, "apikey": apiKey]
    }
    
    fileprivate func info() -> [String: Any] {
        guard case let .info(symbol, type) = self else { return [:] }
        var params = ["function": function, "apikey": apiKey]
        switch type {
        case .stocks: params["symbol"] = symbol
        case .cryptocurrensies, .forex:
            params["from_currency"] = symbol
            params["to_currency"] = "USD"
        }
        return params
    }
    
    fileprivate func update(_ params: inout [String: String], symbol: String) {
        switch type {
        case .stocks:
            params["symbol"] = symbol
        case .cryptocurrensies:
            params["symbol"] = symbol
            params["market"] = "USD"
        case .forex:
            params["from_symbol"] = symbol
            params["to_symbol"] = "USD"
        }
    }
}

func stub(_ name: String) -> Data {
    guard
        let url = Bundle.main.url(forResource: name, withExtension: "json"),
        let data = try? Data(contentsOf: url)
        else { return Data() }
    return data
}

extension SymbolsTarget: Hashable {}

extension SymbolsTarget {
    var type: SymbolsType {
        switch self {
        case .intraday(_, let type, _, _): return type
        case .daily(_, let type, _): return type
        case .monthly(_, let type): return type
        case .search: return .stocks
        case .info(_, let type): return type
        }
    }
    
    var function: String {
        switch self {
        case .intraday(_, let type, _, _):
            switch(type) {
            case .stocks: return "TIME_SERIES_INTRADAY"
            case .cryptocurrensies: return "DIGITAL_CURRENCY_DAILY"
            case .forex: return "FX_INTRADAY"
            }
        case .daily(_, let type, _):
            switch(type) {
            case .stocks: return "TIME_SERIES_DAILY"
            case .cryptocurrensies: return "DIGITAL_CURRENCY_DAILY"
            case .forex: return "FX_DAILY"
            }
        case .monthly(_, let type):
            switch(type) {
            case .stocks: return "TIME_SERIES_MONTHLY"
            case .cryptocurrensies: return "DIGITAL_CURRENCY_MONTHLY"
            case .forex: return "FX_MONTHLY"
            }
        case .info(_, let type):
            switch(type) {
            case .stocks: return "GLOBAL_QUOTE"
            case .cryptocurrensies, .forex: return "CURRENCY_EXCHANGE_RATE"
            }
        case .search: return "SYMBOL_SEARCH"
        }
    }
}

enum Interval: String {
    case `default` = "5min"
    case minute = "1min"
    case halfhour = "30min"
    case hour = "60min"
}

/// The "compact" option is recommended if you would like to reduce the data size of each API call.
///
/// - compact: returns only the latest 100 data points in the intraday time series
/// - full: returns the full-length time series
enum OutputSize: String {
    case compact
    case full
}
