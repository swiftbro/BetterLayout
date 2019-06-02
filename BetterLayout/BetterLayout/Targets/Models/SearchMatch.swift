//
//  SearchMatch.swift
//  Trading
//
//  Created by Vlad Che on 2/27/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import Foundation

struct SearchMatch: Codable {
    let symbol: String
    let name: String
    let type: String
    let region: String
    let marketOpen: String
    let marketClose: String
    let timeZone: String
    let currency: String
    let score: String
    
    init(from decoder: Decoder) throws {
        symbol = try decoder.decode(Key.symbol)
        name = try decoder.decode(Key.name)
        type = try decoder.decode(Key.type)
        region = try decoder.decode(Key.region)
        marketOpen = try decoder.decode(Key.marketOpen)
        marketClose = try decoder.decode(Key.marketClose)
        timeZone = try decoder.decode(Key.zone)
        currency = try decoder.decode(Key.currency)
        score = try decoder.decode(Key.score)
    }
}

struct SearchResponse: Codable {
    let bestMatches: [SearchMatch]
}
