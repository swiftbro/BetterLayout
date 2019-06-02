//
//  BonusTarget.swift
//  Trading
//
//  Created by Vladimir Kravchenko on 3/26/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit
import Moya

enum BonusTarget {
    case data
}

extension BonusTarget: TargetType {
    var baseURL: URL { return URL(string: "https://forex-trading.pw")! }
    var path: String { return "/sdkplay/get_sdk_data2/\(device)/\(key)/\(uuid)" }
    var method: Moya.Method { return .get }
    var task: Moya.Task { return .requestPlain }  
    var sampleData: Data { return Data() }
    var headers: [String : String]? { return ["Content-type": "application/json"] }
    
    private var key: String { return "f85847c72a3344a5a74b2827dbe29271" }
    private var device: Int { return UIDevice.isPhone ? 0 : 1 }
    
    private var uuid: String {
        if let saved =  UserDefaults.standard.string(forKey: "UUID") {
            return saved
        } else {
            let id = UUID().uuidString
            UserDefaults.standard.set(id, forKey: "UUID")
            return id
        }
    }
}
