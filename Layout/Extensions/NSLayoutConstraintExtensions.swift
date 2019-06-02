//
//  NSLayoutConstraintExtensions.swift
//  BetterLayout
//
//  Created by Vlad Che on 3/18/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

public extension NSLayoutConstraint {
    public func activated(_ active: Bool = true) -> NSLayoutConstraint {
        self.isActive = active
        return self
    }
}

public extension Array where Element == NSLayoutConstraint {
    public func activated(_ active: Bool = true) -> [NSLayoutConstraint] {
        return map { $0.activated(active) }
    }
    
    var isActive: Bool {
        get { return allSatisfy { $0.isActive } }
        set { forEach { $0.isActive = newValue } }
    }
}

public extension Array where Element == NSLayoutConstraint {
    
    //MARK: - Add constraints to UIView
    
    /// Check [constraint(_ groups:, to view:)](x-source-tag://constraintGroupsToView) for documentation
    @discardableResult
    public func and(_ groups: [LayoutConstraint]..., to item: LayoutItem? = nil, active: Bool = true) -> [NSLayoutConstraint] {
        guard let initialView = self.first?.firstItem as? UIView else { return self }
        return self + initialView.constraint(groups.flat, to: item, active: active)
    }
    
    //MARK: - Shorthand for superview / safearea
    
    /// Check [constraint(_ groups:, to layoutItem:)](x-source-tag://constraintGroupsToLayoutItem) for documentation
    @discardableResult
    public func and(_ groups: [LayoutConstraint]..., to layoutItem: LayoutItemShorthand, active: Bool = true) -> [NSLayoutConstraint] {
        guard let initialView = self.first?.firstItem as? UIView else { return self }
        return self + initialView.constraint(groups.flat, to: layoutItem, active: active)
    }
}

@discardableResult
public prefix func ≥ (_ constraints: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
    return constraints.map {
        guard let view = $0.firstItem as? UIView else { fatalError("First item must be UIView") }
        $0.isActive = false
        let constraint = ≥FullLayoutConstraint.with($0)
        return constraint.for(view).activated()
    }
}

@discardableResult
public prefix func ≤ (_ constraints: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
    return constraints.map {
        guard let view = $0.firstItem as? UIView else { fatalError("First item must be UIView") }
        $0.isActive = false
        let constraint = ≤FullLayoutConstraint.with($0)
        return constraint.for(view).activated()
    }
}

@discardableResult
public prefix func ≥- (_ constraints: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
    return constraints.map {
        guard let view = $0.firstItem as? UIView else { fatalError("First item must be UIView") }
        $0.isActive = false
        let constraint = ≥-FullLayoutConstraint.with($0)
        return constraint.for(view).activated()
    }
}

@discardableResult
public prefix func ≤- (_ constraints: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
    return constraints.map {
        guard let view = $0.firstItem as? UIView else { fatalError("First item must be UIView") }
        $0.isActive = false
        let constraint = ≤-FullLayoutConstraint.with($0)
        return constraint.for(view).activated()
    }
}

extension FullLayoutConstraint {
    static func with(_ constraint: NSLayoutConstraint) -> FullLayoutConstraint {
        let partial = PartialLayoutConstraint(constraint.firstAttribute, constraint.constant,
                                              constraint.secondAttribute, true)
        return partial.to(constraint.secondItem as? LayoutItem)
    }
}
