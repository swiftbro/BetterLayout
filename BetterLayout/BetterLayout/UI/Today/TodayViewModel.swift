//
//  TodayViewModel.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import Foundation
import PromiseKit

class TodayViewModel {
    
    let list: Watchlist<MarketItem>
    
    // MARK: Init
    
    init(portfolio: Watchlist<MarketItem>) {
        self.list = portfolio
    }
    
    var isPortfolio: Bool { return list === Portfolio.list }
    
    var info: Promise<TodayInfo?> {
        if savedInfo.isPending { return savedInfo.map(self.todayInfo) }
        guard
            let info = savedInfo.value,
            let first = info.first,
            first.date.getInterval(toDate: Date(), component: .minute) < 1
            else { return getInfo() }
        return savedInfo.map(self.todayInfo)
    }
    
    func items(for period: HistoryPeriod) -> Promise<[SymbolItem]> {
        currentPeriod = period
        return when(fulfilled: info, getItems()).map { $0.1 }
    }
    
    //MARK: - Private
    private let service = SymbolsService.shared
    private let infoService = InfoService.shared
    private var currentPeriod: HistoryPeriod?
    private var savedInfo: Promise<[SymbolInfo]> = Promise.value([])
    
    private func promise(for item: MarketItem) -> Promise<Symbol> {
        guard let period = currentPeriod else { fatalError("No period") }
        let promise: Promise<Symbol>
        switch period {
        case .day: promise = self.service.getIntraday(for: item.code, type: item.type)
        case .week: promise = self.service.getWeek(for: item.code, type: item.type)
        case .month: promise = self.service.getMonth(for: item.code, type: item.type)
        case .quarter: promise = self.service.getQuarter(for: item.code, type: item.type)
        case .year: promise = self.service.getYear(for: item.code, type: item.type)
        case .all: promise = self.service.getAll(for: item.code, type: item.type)
        }
        return promise.filter(for: period)
    }
    
    private func getInfo() -> Promise<TodayInfo?> {
        if list.items.isEmpty { return Promise.value(nil) }
        let promises = list.items.map { self.infoService.getInfo(for: $0.code, type: $0.type) }
        savedInfo = when(fulfilled: promises.makeIterator(), concurrently: 3)
        return savedInfo.map(todayInfo)
    }
    
    private func getItems() -> Promise<[SymbolItem]> {
        guard !list.items.isEmpty else { return Promise.value([]) }
        let period = currentPeriod
        let promises = list.items.map(promise)
        return when(fulfilled: promises.makeIterator(), concurrently: 3)
            .get { _ in if period != self.currentPeriod { throw PMKError.cancelled } }
            .mapValues(SymbolItem.init)
            .mapValues(update)
    }
    
    private func update(_ item: SymbolItem) -> SymbolItem {
        let matchItem: (SymbolInfo) -> Bool = { $0.code == item.code && $0.type == item.type }
        if let info = self.savedInfo.value?.first(where: matchItem) { return item.appending(info) }
        return item
    }
    
    private var portfolioName: String {
        let dots = list.items.count > 3 ? "..." : ""
        return list.items.prefix(3).map(\.code).joined(separator: ", ") + dots
    }
    
    private var portfolioDescription: String {
        return "Total of $\(Portfolio.availableCash.maxFractions(2)) and "
    }
    
    private func todayInfo(for infos: [SymbolInfo]) -> TodayInfo? {
        guard let info = infos.last, let item = list.items.last else { return nil }
        let name = isPortfolio ? portfolioName : info.name ?? item.name
        let description = isPortfolio ? portfolioDescription : info.code
        var price: Float = infos.reduce(0, {
            if self.isPortfolio {
                let total = $1.price * Portfolio.amount(ofItemWith: $1.code, type: $1.type)
                print("+ \($1.code):\t \(total) \t= $\($1.price) x \(Portfolio.amount(ofItemWith: $1.code, type: $1.type))")
                return $0 + total
            } else {
                return $0 + $1.price
            }
        })
        if isPortfolio {
            print("+ Cash:\t \(Portfolio.availableCash)\n=")
            price += Portfolio.availableCash
            print("Total:\t \(price)\n------------------")
        }
        let today = TodayInfo(name: name, description: description,
                              amount: price, isPortfolio: isPortfolio)
        if isPortfolio { Portfolio.currentInfo = today }
        return today
    }

}

struct TodayInfo: Codable {
    let name: String
    let description: String
    let amount: Float
    let isPortfolio: Bool
    
    init(name: String, description: String, amount: Float = 0, isPortfolio: Bool = false) {
        self.name = name; self.description = description; self.amount = amount; self.isPortfolio = isPortfolio
    }
    
    static var empty: TodayInfo {
        return TodayInfo(name: "", description: "", amount: 0, isPortfolio: true)
    }
}
