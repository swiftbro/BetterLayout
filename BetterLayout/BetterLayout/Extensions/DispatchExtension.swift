//
//  DispatchExtension.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import Foundation

extension DispatchQueue {
    static var map: DispatchQueue { return mapQueue }
}

fileprivate var mapQueue = DispatchQueue(label: "Promise.Map.Queue", qos: DispatchQoS.userInitiated, attributes: .concurrent)
