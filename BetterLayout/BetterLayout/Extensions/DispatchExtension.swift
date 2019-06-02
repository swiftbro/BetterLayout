//
//  DispatchExtension.swift
//  Trading
//
//  Created by Vladimir Kravchenko on 2/28/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import Foundation

extension DispatchQueue {
    static var map: DispatchQueue { return mapQueue }
}

fileprivate var mapQueue = DispatchQueue(label: "Promise.Map.Queue", qos: DispatchQoS.userInitiated, attributes: .concurrent)
