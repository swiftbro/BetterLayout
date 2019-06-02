//
//  Watchlist.swift
//  Trading
//
//  Created by Vlad Che on 3/4/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import Foundation

struct WatchlistObserver<Item>: Equatable {
    weak var observer: AnyObject?
    let action: ([Item]) -> Void
    
    static func ==(lhs: WatchlistObserver, rhs: WatchlistObserver) -> Bool {
        return lhs.observer === rhs.observer
    }
}

class Watchlist<Item> {
    fileprivate(set) var items: [Item] {
        didSet { notifyObservers() }
    }
    
    init(items: [Item]) {
        self.items = items
    }
    
    func addObserver(_ observer: AnyObject, action: @escaping ([Item]) -> Void) {
        let newObserver = WatchlistObserver(observer: observer, action: action)
        if let index = observers.firstIndex(of: newObserver) {
            observers[index] = newObserver
        } else {
            observers.append(newObserver)
        }
    }
    
    func removeObserver(_ observer: AnyObject) {
        if let index = observers.firstIndex(where: { $0.observer === observer }) {
            observers.remove(at: index)
        }
    }
    
    fileprivate var observers: [WatchlistObserver<Item>] = []
    
    fileprivate func notifyObservers() {
        observers.removeAll(where: { $0.observer == nil })
        for observer in observers { observer.action(items) }
    }
}

class Portfolio {
    
    // MARK: - Items -
    
    static fileprivate(set) var list = Watchlist(items: items)
    static fileprivate(set) var operationsList = Watchlist(items: operations)
    static var currentInfo: TodayInfo? = getInfo() { didSet { saveInfo() } }
    
    static func add(_ item: MarketItem, amount: Float, price: Float) {
        let operation = Operation(item, amount, price)
        save(operation)
    }
    
    static func remove(_ item: MarketItem, amount: Float, price: Float) {
        let operation = Operation(item, -amount, price)
        save(operation)
    }
    
    static func amount(of item: MarketItem) -> Float {
        let amount = self.operations.filter { $0.item == item }.map(\.amount).reduce(0, +)
        return amount
    }
    
    static func amount(ofItemWith code: String, type: SymbolsType, till date: Date = Date()) -> Float {
        let itemOperations = operations.filter { $0.item.code == code && $0.item.type == type && date >= $0.date }
        return itemOperations.map(\.amount).reduce(0, +)
    }
    
    static func export() -> Data {
        let data = PortfolioData(cash: availableCash, operations: operations, updates: cashUpdates)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        encoder.dateEncodingStrategy = .iso8601
        return try! encoder.encode(data)
    }
    
    static func `import`(_ data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let info = try decoder.decode(PortfolioData.self, from: data)
        operations = info.operations
        cashUpdates = info.updates
        availableCash = info.cash
        if let data = try? JSONEncoder().encode(cashUpdates) {
            UserDefaults.standard.set(data, forKey: Key.cashTimeSeries)
        }
        if let data = try? JSONEncoder().encode(operations) {
            UserDefaults.standard.set(data, forKey: Key.portfolio)
            list.items = self.items
            operationsList.items = operations
        }
    }
    
    // MARK: - Cash -
    
    static fileprivate(set) var availableCash: Float = getCash() { didSet { saveCash() } }
    static fileprivate(set) var cashUpdates: [CashTimeSerie] = getCashTimeSeries()
    static let startCash: Float = 100_000
    
    // MARK: - Private -
    
    static private var operations: [Operation]  = getOperations()
    
    private static var items: [MarketItem] {
        return operations.map(\.item).orderedSet.filter({ amount(of: $0) > 0})
    }
    
    private static func save(_ operation: Operation) {
        operations.append(operation)
        if let data = try? JSONEncoder().encode(operations) {
            UserDefaults.standard.set(data, forKey: Key.portfolio)
            updateCash(with: operation)
            list.items = self.items
            operationsList.items = operations
        }
    }
    
    fileprivate static func updateCash(with operation: Operation) {
        availableCash -= operation.price * operation.amount
        let timeSerie = CashTimeSerie(cash: availableCash, date: operation.date, operation: operation)
        cashUpdates.append(timeSerie)
        if let data = try? JSONEncoder().encode(cashUpdates) {
            UserDefaults.standard.set(data, forKey: Key.cashTimeSeries)
        }
    }
    
    private static func getCash() -> Float {
        if let cash = UserDefaults.standard.value(forKey: Key.cash) as? Float {
            return cash
        } else {
            return startCash
        }
    }
    
    private static func saveCash() {
        UserDefaults.standard.set(availableCash, forKey: Key.cash)
    }
    
    private static func getInfo() -> TodayInfo? {
        guard
            let data = UserDefaults.standard.data(forKey: Key.info),
            let info = try? JSONDecoder().decode(TodayInfo?.self, from: data)
            else { return nil }
        return info
    }
    
    private static func saveInfo() {
        guard
            let data = try? JSONEncoder().encode(currentInfo)
            else { return }
        UserDefaults.standard.set(data, forKey: Key.info)
    }
    
    private static func getOperations() -> [Operation] {
        guard
            let data = UserDefaults.standard.data(forKey: Key.portfolio),
            var items = try? JSONDecoder().decode([Operation].self, from: data)
            else {return []}
        items.updateForTest()
        return items
    }
    
    private static func getCashTimeSeries() -> [CashTimeSerie] {
        guard let data = UserDefaults.standard.data(forKey: Key.cashTimeSeries),
            let items = try? JSONDecoder().decode([CashTimeSerie].self, from: data)
            else {return []}
        return items
    }
    
    struct Operation: Codable {
        var date: Date
        let item: MarketItem
        let amount: Float
        let price: Float
        
        init(_ item: MarketItem, _ amount: Float, _ price: Float) {
            self.date = Date(); self.item = item; self.amount = amount; self.price = price
        }
    }
    
    struct CashTimeSerie: Codable {
        let cash: Float
        var date: Date
        var operation: Operation
    }
}

class SavedEquities {
    
    static fileprivate(set) var list: Watchlist = Watchlist(items: items)
    
    static func add(_ item: MarketItem) {
        var items = self.items
        guard !contains(item) else { return }
        items.append(item)
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: Key.list)
            list.items = items
        }
    }
    
    static func remove(_ item: MarketItem) {
        var items = self.items
        guard let index = items.firstIndex(of: item) else { return }
        items.remove(at: index)
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: Key.list)
            list.items = items
        }
    }
    
    static func contains(_ item: MarketItem) -> Bool {
        return items.contains(item)
    }
    
    private static var items: [MarketItem] {
        guard let data = UserDefaults.standard.data(forKey: Key.list),
        let items = try? JSONDecoder().decode([MarketItem].self, from: data)
        else {return []}
        return items
    }
}

fileprivate enum Key {
    static let list = "Saved.Watchlist"
    static let portfolio = "Saved.Portfolio"
    static let cash = "Saved.Portfolio.Cash"
    static let cashTimeSeries = "Saved.Portfolio.CashTimeSeries"
    static let info = "Saved.Portfolio.Info"
}

extension Array where Element == Portfolio.Operation {
    fileprivate mutating func updateForTest() {
        return
        var items = Array(self.prefix(4))
        items[0].date = "2019-03-06 14:55:00 +0000".toDate(style: .custom("yyyy-MM-dd HH:mm:ss ZZZ"))!.date
        items[1].date = "2019-03-06 16:35:00 +0000".toDate(style: .custom("yyyy-MM-dd HH:mm:ss ZZZ"))!.date
        items[2].date = "2019-03-06 18:05:00 +0000".toDate(style: .custom("yyyy-MM-dd HH:mm:ss ZZZ"))!.date
        items[3].date = "2019-03-06 19:05:00 +0000".toDate(style: .custom("yyyy-MM-dd HH:mm:ss ZZZ"))!.date
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: Key.portfolio)
        }
        UserDefaults.standard.set(nil, forKey: Key.cashTimeSeries)
        Portfolio.availableCash = Portfolio.startCash
        items.forEach({ Portfolio.updateCash(with: $0 )})
        self = items
    }
}

struct PortfolioData: Codable {
    let cash: Float
    let operations: [Portfolio.Operation]
    let updates: [Portfolio.CashTimeSerie]
}
