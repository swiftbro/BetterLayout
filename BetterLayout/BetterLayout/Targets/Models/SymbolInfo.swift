//
//  SymbolInfo.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import Foundation

struct SymbolInfo: Codable {
    let name: String?
    let code: String
    
    let price: Float
    let high: Float
    let low: Float
    let open: Float
    let close: Float
    let volume: Float
    
    let change: Float?
    let percent: Float?
    let date: Date
    var type: SymbolsType = .stocks
    
    func with(type: SymbolsType) -> SymbolInfo {
        var `self` = self
        self.type = type
        return self
    }
    
    init(from decoder: Decoder) throws {
        self.name = try? decoder.decode(Key.name)
        
        let symbol: String? = try? decoder.decode(Key.symbol)
        self.code = try symbol ?? decoder.decode(Key.code)
        
        let date: Date? = try? decoder.decode(Key.date)
        self.date = date ?? Date()
        
        let rate: String? = try? decoder.decode(Key.rate)
        let priceString: String = try rate ?? decoder.decode(Key.price)
        
        let price = try Float(priceString).orThrow("Price has wrong format")
        let low = try? Float(decoder.decode(Key.low) as String).orThrow("Wrong number format")
        let high = try? Float(decoder.decode(Key.high) as String).orThrow("Wrong number format")
        let open = try? Float(decoder.decode(Key.open) as String).orThrow("Wrong number format")
        let volume = try? Float(decoder.decode(Key.volume) as String).orThrow("Wrong number format")
        self.low = low ?? price
        self.high = high ?? price
        self.open = open ?? price
        self.close = price
        self.volume = volume ?? 0
        self.price = price
        self.change = try? decoder.decode(Key.change)
        self.percent = try? decoder.decode(Key.percent)
    }
}

struct SymbolInfoResponse: Codable {
    let info: SymbolInfo
    
    init(from decoder: Decoder) throws {
        info = try decoder.decode("")
    }
}
