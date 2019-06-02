//
//  Layout.swift
//  BetterLayout
//
//  Created by Vlad Che on 2/20/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

public extension UIView {
    
    //MARK: - Constraints to UIView
    @discardableResult
    func layout(_ groups: [FullLayoutConstraint]..., to item: LayoutItem? = nil) -> [NSLayoutConstraint] {
        return layout(groups.flat, to: item, active: true)
    }

    @discardableResult
    func layout(_ groups: [PartialLayoutConstraint]..., to item: LayoutItem? = nil) -> [NSLayoutConstraint] {
        return layout(groups.flat, to: item, active: true)
    }
    
    @discardableResult
    func layout(_ groups: [LayoutConstraint]..., to item: LayoutItem? = nil, active: Bool = true) -> [NSLayoutConstraint] {
        return constraint(groups.flat, to: item, active: active)
    }
    
    @discardableResult
    func layout(_ groups: [LayoutConstraint]..., to layoutItem: LayoutItemShorthand, active: Bool = true) -> [NSLayoutConstraint] {
        return constraint(groups.flat, to: layoutItem, active: active)
    }
    
    /// Creates constraints for view
    /// - Tag: constraintGroupsToView
    /// - Important: if **item** parameter is nil
    ///              and constraints' **hasItem** property is false
    ///              it will create constraints to superview
    /// - Parameters:
    ///   - groups:     layout constraints
    ///   - item:       UIView or UILayoutGuide for the right side of the constraint (**NSLayoutConstrained.secondItem**),
    ///                 optional (see important note)
    ///
    /// - Example:
    ///````
    /// view.layout(10.below[navigationBar], 15.leading.trailing[.safearea], 50%[superview.height])
    /// activityIndicator.layout(view.center)
    /// textLabel.layout(view.topEdge + 10, pin.leadingEdge.trailingEdge ≥ 15, .centerX, to: view)
    ///````
    @discardableResult
    func constraint(_ groups: [LayoutConstraint]...,
                           to item: LayoutItem? = nil,
                           active: Bool = true) -> [NSLayoutConstraint] {
        return groups.flat.map{ constraint($0, to: item, active: active) }
    }
    
    /// Creates constraint for view
    /// - Tag: constraintItemToView
    /// - Important: if **item** parameter is nil
    ///              and constraint's **hasItem** property is false
    ///              it will create constraint to superview
    /// - Parameters:
    ///   - constraint: layout constraint
    ///   - item:       UIView or UILayoutGuide for the right side of the constraint (**NSLayoutConstrained.secondItem**),
    ///                 optional (see important note)
    ///   - forsed:     set view even if it was already set, default is *false*
    @discardableResult
    func constraint(_ constraint: LayoutConstraint,
                           to item: LayoutItem? = nil,
                           active: Bool = true) -> NSLayoutConstraint {
        if let partial = constraint as? ViewSettable, partial.isMutable, let item = item {
            return partial.to(item).for(self).activated(active)
        }
        return constraint.for(self).activated(active)
    }
    
    //MARK: - Shorthand for superview / safearea
    
    /// Creates constraints to superview or safe area
    /// - Tag: constraintGroupsToLayoutItem
    /// - Important: Check [constraint(_ groups:, to view:)](x-source-tag://constraintGroupsToView) for details
    /// - Parameters:
    ///   - groups:         layout constraints
    ///   - layoutItem:     superview or safearea
    @discardableResult
    public func constraint(_ groups: [LayoutConstraint]...,
                           to layoutItem: LayoutItemShorthand,
                           active: Bool = true) -> [NSLayoutConstraint] {
        return groups.flat.map{ constraint($0, to: layoutItem, active: active) }
    }
    
    /// Creates constraint to superview or safe area
    /// - Tag: constraintItemToLayoutItem
    /// - Parameters:
    ///   - item:           layout constraint
    ///   - layoutItem:     superview or safearea
    @discardableResult
    public func constraint(_ constraint: LayoutConstraint,
                           to layoutItem: LayoutItemShorthand,
                           active: Bool = true) -> NSLayoutConstraint {
        if let partial = constraint as? ViewSettable, partial.isMutable {
            return partial.to(layoutItem).for(self).activated(active)
        }
        return constraint.for(self).activated(active)
    }
}

public enum LayoutItemShorthand {
    case superview, safearea
}
