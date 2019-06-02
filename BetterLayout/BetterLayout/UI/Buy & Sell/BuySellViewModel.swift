//
//  BuySellViewModel.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import Foundation
import PromiseKit

class BuySellViewModel {
    let operation: Operation
    let item: MarketItem
    private let servise = InfoService.shared
    lazy private(set) var price: Promise<Float> =
        servise.getInfo(for: item.code, type: item.type, cancelPrevious: true).map { $0.price }
    
    // MARK: Init
    
    init(with item: MarketItem, operation: Operation) {
        self.item = item
        self.operation = operation
    }
    
    func operate(amount: Float) throws {
        guard let price = price.value else { throw "Price is not fetched yet" }
        if operation == .buy {
            Portfolio.add(item, amount: amount, price: price)
        } else {
            Portfolio.remove(item, amount: amount, price: price)
        }
    }
    
    var availableText: String {
        switch operation {
        case .buy:
            let amount = Portfolio.amount(of: item)
            let inPortfolio = amount > 0 ? "\(amount) \(item.code) in portfolio \n" : ""
            return inPortfolio + "\(maxAmount.maxFractions(2)) \(item.code) available"
        case .sell: return "\(maxAmount) \(item.code) available"
        }
    }
    
    var maxAmount: Float {
        guard let price = price.value else { return 0 }
        switch operation {
        case .buy: return Portfolio.availableCash / price
        case .sell: return Portfolio.amount(of: item)
        }
    }
    
    enum Operation {
        case sell
        case buy
        
        var color: UIColor {
            switch self {
            case .sell: return #colorLiteral(red:1, green:0.23, blue:0.45, alpha:1)
            case .buy: return #colorLiteral(red:0.02, green:0.69, blue:0.5, alpha:1)
            }
        }
        
        var title: String {
            switch self {
            case .sell: return "Sell"
            case .buy: return "Buy"
            }
        }
    }
}
