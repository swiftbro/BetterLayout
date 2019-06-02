//
//  SymbolsService.swift
//  Trading
//
//  Created by Vladimir Kravchenko on 1/29/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import Foundation
import Moya
import PromiseKit
import SwiftDate

class SymbolsService {
    static let shared = SymbolsService()
    private let provider = MoyaProvider<SymbolsTarget>.default
    
    /// Returns intraday time series (timestamp, open, high, low, close, volume) of the equity specified.
    /// - Important: Interval: 5 minutes, Limit: 100 series
    ///
    /// - Parameters:
    ///     - symbol: The name of the equity of your choice. For example: AAPL
    ///     - type: cryptocurrencies, stocks or forex
    func getIntraday(for symbol: String, type: SymbolsType = .stocks) -> Promise<Symbol> {
        if type == .cryptocurrensies { return getCryptDaily(symbol, 10) }
        return getHistory(.intraday(symbol, type, .default, .compact), limit: 100)
    }
    
    /// Returns hourly time series (date, daily open, daily high, daily low,
    /// daily close, daily volume) of the global equity specified,
    /// covering 1 week of historical data.
    ///
    /// - Parameters:
    ///     - symbol: The name of the equity of your choice. For example: AAPL
    ///     - type: cryptocurrencies, stocks or forex
    func getWeek(for symbol: String, type: SymbolsType = .stocks) -> Promise<Symbol> {
        if type == .cryptocurrensies {  return getCryptDaily(symbol, 10) }
        return getHistory(.intraday(symbol, type, .hour, .compact), limit: 100)
    }
    
    /// Returns hourly time series (date, daily open, daily high, daily low,
    /// daily close, daily volume) of the global equity specified,
    /// covering 1 months of historical data.
    ///
    /// - Parameters:
    ///     - symbol: The name of the equity of your choice. For example: AAPL
    ///     - type: cryptocurrencies, stocks or forex
    func getMonth(for symbol: String, type: SymbolsType = .stocks) -> Promise<Symbol> {
        if type == .cryptocurrensies { return getCryptDaily(symbol, 30) }
        return getHistory(.intraday(symbol, type, .hour, .full), limit: 250)
    }
    
    /// Returns daily time series (date, daily open, daily high, daily low,
    /// daily close, daily volume) of the global equity specified,
    /// covering 3 months of historical data.
    ///
    /// - Parameters:
    ///     - symbol: The name of the equity of your choice. For example: AAPL
    ///     - type: cryptocurrencies, stocks or forex
    func getQuarter(for symbol: String, type: SymbolsType = .stocks) -> Promise<Symbol> {
        if type == .cryptocurrensies { return getCryptDaily(symbol, 100) }
        return getHistory(.daily(symbol, type, .compact), limit: 100)
    }
    
    /// Returns daily time series (date, daily open, daily high, daily low,
    /// daily close, daily volume) of the global equity specified,
    /// covering 1 years of historical data.
    ///
    /// - Parameters:
    ///     - symbol: The name of the equity of your choice. For example: AAPL
    ///     - type: cryptocurrencies, stocks or forex
    func getYear(for symbol: String, type: SymbolsType = .stocks) -> Promise<Symbol> {
        return getHistory(.daily(symbol, type, .full), limit: 365)
    }
    
    /// Returns weekly time series (last trading day of each week, weekly open,
    /// weekly high, weekly low, weekly close, weekly volume)
    /// of the global equity specified, covering 20+ years of historical data.
    ///
    /// - Parameters:
    ///     - symbol: The name of the equity of your choice. For example: AAPL
    ///     - type: cryptocurrencies, stocks or forex
    func getAll(for symbol: String, type: SymbolsType = .stocks) -> Promise<Symbol> {
        return getHistory(.monthly(symbol, type))
    }
    
    private func getCryptDaily(_ symbol: String, _ limit: Int) -> Promise<Symbol> {
        return getHistory(.daily(symbol, .cryptocurrensies, .full), limit: limit)
    }
    
    private func getHistory(_ target: SymbolsTarget, limit: Int? = nil) -> Promise<Symbol> {
        var token = CancelToken()
        return getHistory(target, limit: limit, token: &token)
    }
    
    private func getHistory(_ target: SymbolsTarget, limit: Int? = nil, token: inout CancelToken) -> Promise<Symbol> {
        let response: Promise<Moya.Response>
        if let cached = cache[target], abs(cached.date.timeIntervalSinceNow) < interval(for: target) {
            response = Promise.value(cached.response)
        } else {
            cache[target] = nil
            response = provider.request(target, token: &token).get { self.cache[target] = ResponseCache($0) }
        }
        let symbol = response
            .filterSuccessfulStatusCodes()
            .mapResponse { try limitSymbols($0, limit) }
            .mapResponse(dictionaryToArray)
            .decode(SymbolResponse.self)
            .map { return Symbol(with: $0).with(type: target.type) }
            .recover({ (error) -> Promise<Symbol> in
                self.cache[target] = nil
                throw error
            })
        return attempt(3) { symbol }
    }
    
    private func interval(for target: SymbolsTarget) -> TimeInterval {
        switch target {
        case .intraday: return 1.hours.timeInterval
        default: return 1.days.timeInterval
        }
    }
    
    private var cache: [SymbolsTarget: ResponseCache] = [:]
}

extension SymbolsService: SymbolsProvider {
    func get(_ symbol: String, type: SymbolsType, token: inout CancelToken) -> Promise<Symbol> {
        switch type {
        case .stocks, .forex:
            return getHistory(.intraday(symbol, type, .default, .compact), limit: 100, token: &token).filter(for: .day)
        case .cryptocurrensies:
            return getHistory(.daily(symbol, .cryptocurrensies, .full), limit: 30, token: &token).filter(for: .month)
        }
    }
}

struct ResponseCache {
    let response: Moya.Response
    let date: Date
    
    init(_ response: Moya.Response) {
        self.response = response
        self.date = Date()
    }
}

/// cryptocurrencies, stocks or forex
enum SymbolsType: Int, Codable {
    case cryptocurrensies
    case stocks
    case forex
    
    var title: String {
        switch self {
        case .cryptocurrensies: return L.Market.cryptocurrencies
        case .stocks: return L.Market.stocks
        case .forex: return L.Market.forex
        }
    }
}

private func dictionaryToArray(_ json: String) throws -> String {
    guard let zone = json.endIndex(ofFirst: MetaData.Key.timeZone),
        let series = json.endIndex(of: Symbol.Key.series, after: zone),
        let openBracerRange = json.range(of: "{", after: series),
        let last = json.index(.last),
        let closeBracerRange = json.range(of: "}", before: last)
        else {return json}
    let changed = json.replacingOccurrences(of: "{", with: "[", range: openBracerRange)
        .replacingOccurrences(of: "}", with: "]", range: closeBracerRange)
    
    let regex = try NSRegularExpression(pattern: "\\\"\\d{4}-\\d{2}-\\d{2}.{0,20}?\\{(?:(?!\\{).)*?\\}",
                                        options: [.caseInsensitive, .dotMatchesLineSeparators])
    let result = regex.stringByReplacingMatches(in: changed, options: [], range: NSMakeRange(0, json.count), withTemplate: "{$0}")
    return result
}

private func limitSymbols(_ json: String, _ limit: Int?) throws -> String {
    guard let limit = limit else { return json }
    let regex = try NSRegularExpression(pattern: "\\\"\\d{4}-\\d{2}-\\d{2}.{0,20}?\\{(?:(?!\\{).)*?\\}.",
                                        options: [.caseInsensitive, .dotMatchesLineSeparators])
    let matches = regex.matches(in: json, options: [], range: NSMakeRange(0, json.count))
    guard matches.count > limit else { return json }
    let range = Range(matches[limit].range, in: json)!.lowerBound..<json.endIndex
    let result = json.replacingCharacters(in: range, with: "}}")
    return result
}
