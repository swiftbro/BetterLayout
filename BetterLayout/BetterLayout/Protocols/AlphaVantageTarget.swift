//
//  AlphaVantageTarget.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import Foundation
import Moya

protocol AlphaVantageTarget: TargetType {}

extension AlphaVantageTarget {
    var baseURL: URL { return URL(string: "https://www.alphavantage.co")! }
    var path: String { return "/query" }
    var method: Moya.Method { return .get }
    var sampleData: Data { return Data() }
    var headers: [String : String]? { return ["Content-type": "application/json"] }    
    var apiKey: String { return "JBAQOPJG5X5W6C3L" }
}

struct AnyTarget: AlphaVantageTarget {
    var task: Moya.Task { return .requestPlain }
    let request: URLRequest
    init(with request: URLRequest) {
        self.request = request
    }
}
