//
//  AlphaVantageTarget.swift
//  Trading
//
//  Created by Vladimir Kravchenko on 1/29/19.
//  Copyright © 2019 Digicode. All rights reserved.
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
