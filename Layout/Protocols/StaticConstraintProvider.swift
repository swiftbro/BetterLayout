//
//  StaticConstraintProvider.swift
//  BetterLayout
//
//  Created by Vlad Che on 2/23/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

public let pin: [PartialLayoutConstraint] = []

public protocol StaticConstraintProvider {
    static var top: [PartialLayoutConstraint] { get }
    static var bottom: [PartialLayoutConstraint] { get }
    static var leading: [PartialLayoutConstraint] { get }
    static var trailing: [PartialLayoutConstraint] { get }
    static var left: [PartialLayoutConstraint] { get }
    static var right: [PartialLayoutConstraint] { get }
    
    static var above: [PartialLayoutConstraint] { get }
    static var below: [PartialLayoutConstraint] { get }
    static var before: [PartialLayoutConstraint] { get }
    static var after: [PartialLayoutConstraint] { get }
    
    static var topEdge: [PartialLayoutConstraint] { get }
    static var bottomEdge: [PartialLayoutConstraint] { get }
    static var leadingEdge: [PartialLayoutConstraint] { get }
    static var trailingEdge: [PartialLayoutConstraint] { get }
    
    static var centerX: [PartialLayoutConstraint] { get }
    static var centerY: [PartialLayoutConstraint] { get }
    
    static var width: [PartialLayoutConstraint] { get }
    static var height: [PartialLayoutConstraint] { get }
    
    static var edges: [PartialLayoutConstraint] { get }
    static var center: [PartialLayoutConstraint] { get }
}

public extension StaticConstraintProvider {
    public static var top: [PartialLayoutConstraint] { return zero.top }
    public static var bottom: [PartialLayoutConstraint] { return zero.bottom }
    public static var leading: [PartialLayoutConstraint] { return zero.leading }
    public static var trailing: [PartialLayoutConstraint] { return zero.trailing }
    public static var left: [PartialLayoutConstraint] { return zero.left }
    public static var right: [PartialLayoutConstraint] { return zero.right }
    
    public static var above: [PartialLayoutConstraint] { return zero.above }
    public static var below: [PartialLayoutConstraint] { return zero.below }
    public static var before: [PartialLayoutConstraint] { return zero.before }
    public static var after: [PartialLayoutConstraint] { return zero.after }
    
    public static var topEdge: [PartialLayoutConstraint] { return zero.topEdge }
    public static var bottomEdge: [PartialLayoutConstraint] { return zero.bottomEdge }
    public static var leadingEdge: [PartialLayoutConstraint] { return zero.leadingEdge}
    public static var trailingEdge: [PartialLayoutConstraint] { return zero.trailingEdge }
    
    public static var centerX: [PartialLayoutConstraint] { return zero.centerX }
    public static var centerY: [PartialLayoutConstraint] { return zero.centerY }
    
    public static var width: [PartialLayoutConstraint] { return pin.width }
    public static var height: [PartialLayoutConstraint] { return pin.height }
    
    public static var edges: [PartialLayoutConstraint] { return zero.edges }
    public static var center: [PartialLayoutConstraint] { return zero.center }
}

extension Array: StaticConstraintProvider where Element == PartialLayoutConstraint {}
