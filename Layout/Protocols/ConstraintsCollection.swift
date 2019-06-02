//
//  ConstraintsCollection.swift
//  BetterLayout
//
//  Created by Vlad Che on 3/26/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

public protocol ConstraintsCollection {
    associatedtype C
    associatedtype D
    func appending(constraints: [PartialLayoutConstraint]) -> [C]
    func appending(dimensions: [PartialLayoutConstraint]) -> [D]
}

public extension ConstraintsCollection {
    public func appending(dimensions: [PartialLayoutConstraint]) -> [C] {
        return appending(constraints: dimensions)
    }
}

public extension ConstraintsCollection
where Self: ConstraintProvider, C == Self.ProvidableConstraint, D == Self.ProvidableDimension {
    public var width:  [D] { return self += PartialLayoutConstraint(.width, 0) }
    public var height: [D] { return self += PartialLayoutConstraint(.height, 0) }
    
    public var top:      [C] { return self += PartialLayoutConstraint(.top, 0, .bottom) }
    public var bottom:   [C] { return self += PartialLayoutConstraint(.bottom, 0, .top) }
    public var leading:  [C] { return self += PartialLayoutConstraint(.leading, 0, .trailing) }
    public var trailing: [C] { return self += PartialLayoutConstraint(.trailing, 0, .leading) }
    public var left:     [C] { return self += PartialLayoutConstraint(.left, 0, .right) }
    public var right:    [C] { return self += PartialLayoutConstraint(.right, 0, .left) }
    
    public var above:   [C] { return self += PartialLayoutConstraint(.bottom, 0, .top, true) }
    public var below:   [C] { return self += PartialLayoutConstraint(.top, 0, .bottom, true) }
    public var before:  [C] { return self += PartialLayoutConstraint(.trailing, 0, .leading, true) }
    public var after:   [C] { return self += PartialLayoutConstraint(.leading, 0, .trailing, true) }
    
    public var center:  [C] { return self += pin.centerX.centerY }
    public var centerX: [C] { return self += PartialLayoutConstraint(.centerX, 0) }
    public var centerY: [C] { return self += PartialLayoutConstraint(.centerY, 0) }
    
    public var edges:        [C] { return self += pin.leadingEdge.trailingEdge.topEdge.bottomEdge }
    public var topEdge:      [C] { return self += PartialLayoutConstraint(.top, 0, .top, true) }
    public var bottomEdge:   [C] { return self += PartialLayoutConstraint(.bottom, 0, .bottom, true) }
    public var leadingEdge:  [C] { return self += PartialLayoutConstraint(.leading, 0, .leading, true) }
    public var trailingEdge: [C] { return self += PartialLayoutConstraint(.trailing, 0, .trailing, true) }
}

extension Array: ConstraintsCollection where Element: ConstraintsCollection, Element == Element.C {
    
    public typealias C = Element
    public typealias D = Element
    
    public func appending(constraints: [PartialLayoutConstraint]) -> [Element] {
        guard !isEmpty else {
            if let constraints = constraints as? [Element] { return constraints }
            fatalError("Empty array is not supported")
        }
        var `self` = self
        let last = self.removeLast().appending(constraints: constraints)
        return self + last
    }
}

extension Array: ConstraintProvider
where Element: ConstraintsCollection & LayoutConstraint & MutableLayoutConstraint,
      Element == Element.C, Element == Element.ConstraintType {
    public typealias ProvidableConstraint = Element
    public typealias ProvidableDimension = Element
}

public extension ConstraintsCollection {
    public static func += (lhs: Self, rhs: PartialLayoutConstraint) -> [C] {
        return lhs.appending(constraints: [rhs])
    }
    public static func += (lhs: Self, rhs: [PartialLayoutConstraint]) -> [C] {
        return lhs.appending(constraints: rhs)
    }
    public static func += (lhs: Self, rhs: PartialLayoutConstraint) -> [D] {
        return lhs.appending(dimensions: [rhs])
    }
    public static func += (lhs: Self, rhs: [PartialLayoutConstraint]) -> [D] {
        return lhs.appending(dimensions: rhs)
    }
}

extension UIView: ConstraintsCollection {
    public func appending(constraints: [PartialLayoutConstraint]) -> [FullLayoutConstraint] {
        let partial = constraints.map { PartialLayoutConstraint($0.itemAttribute, $0.constant, $0.attribute) }
        return partial.map { FullLayoutConstraint($0, to: self, itemDependent: true) }
    }
}

extension UILayoutGuide: ConstraintsCollection {
    public func appending(constraints: [PartialLayoutConstraint]) -> [FullLayoutConstraint] {
        let partial = constraints.map { PartialLayoutConstraint($0.attribute, $0.constant).preserved }
        return partial[self]
    }
}

public extension ConstraintsCollection where Self: NumericConstraintProvider {
    public func appending(constraints: [PartialLayoutConstraint]) -> [PartialLayoutConstraint] { return constraints + value }
    public func appending(dimensions: [PartialLayoutConstraint]) -> [FullLayoutConstraint] { return dimensions[nil] + value }
}


