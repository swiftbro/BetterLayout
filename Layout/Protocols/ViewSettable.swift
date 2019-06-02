//
//  ViewSettable.swift
//  BetterLayout
//
//  Created by Vlad Che on 3/25/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

public protocol ViewSettable {
    var isMutable: Bool { get }
    /// Set UIView or UILayoutGuide as second item of constraint
    /// - Tag: toView
    /// - Parameters:
    ///   - view:       View or layout guide on the right side of the constraint.
    ///                 Will be tranlated to **NSLayoutConstraint.secondItem**
    /// - Returns: Changed constraint
    func to(_ view: LayoutItem?) -> FullLayoutConstraint
    
    /// Set strict constraint to specified attribute of UIView
    /// - Tag: toAttribute
    /// - Important: Be careful with creating an invalid constraint
    ///             (for example, view1.top == 0.0 x nil.notAnAttribute + 200.0
    ///             or view1.top == 1.0 x view2.height + 20.0)
    /// - Parameters:
    ///   - attribute: The attribute of the view for the right side of the constraint.
    ///                Will be tranlated to **NSLayoutConstraint.secondAttribute**
    ///   - view:      View on the right side of the constraint.
    ///                Will be tranlated to **NSLayoutConstraint.secondItem**
    /// - Returns: Changed constraint
    func to(_ itemAttribute: LayoutAttribute, of view: UIView) -> FullLayoutConstraint
    
    func to(_ itemAttribute: LayoutAttribute) -> PartialLayoutConstraint
    
    /// Set constraint to superview or safe area
    ///
    /// - Parameter itemShorthand: superview or safearea
    func to(_ itemShorthand: LayoutItemShorthand) -> PartialLayoutConstraint
}

//MARK: - Array

public extension Sequence where Element: ViewSettable {
    
    /// Set UIView or UILayoutGuide as second item of constraint
    /// - Tag: toViewArray
    /// - Parameters:
    ///   - view:       View or layout guide on the right side of the constraint.
    ///                 Will be tranlated to **NSLayoutConstraint.secondItem**
    /// - Returns: Changed constraints
    public func to(_ item: LayoutItem?) -> [FullLayoutConstraint] {
        return map { $0.to(item) }
    }
    
    /// Set strict constraints to specified attribute of UIView
    ///
    /// - Important: Be careful with creating an invalid constraint
    ///             (for example, view1.top == 0.0 x nil.NotAnAttribute + 200.0
    ///             or view1.top == 1.0 x view2.height + 20.0)
    /// - Parameters:
    ///   - attribute: The attribute of the view for the right side of the constraint.
    ///                Will be tranlated to **NSLayoutConstraint.secondAttribute**
    ///   - view:      View on the right side of the constraint.
    ///                Will be tranlated to **NSLayoutConstraint.secondItem**
    /// - Returns: Changed constraints
    public func to(_ itemAttribute: LayoutAttribute, of view: UIView) -> [FullLayoutConstraint] {
        return map { $0.to(itemAttribute, of: view) }
    }
    
    public func to(_ itemAttribute: LayoutAttribute) -> [PartialLayoutConstraint] {
        return map { $0.to(itemAttribute) }
    }
    
    /// Set constraint to superview or safe area
    ///
    /// - Parameter itemShorthand: superview or safearea
    public func to(_ itemShorthand: LayoutItemShorthand) -> [PartialLayoutConstraint] {
        return map { $0.to(itemShorthand) }
    }
}

//MARK: - Subscripts

extension Sequence where Element: ViewSettable {
    
    subscript(item: LayoutItem?) -> [FullLayoutConstraint] {
        return self.to(item)
    }
    
    subscript(constraints: [FullLayoutConstraint]) -> [FullLayoutConstraint] {
        guard let constraint = constraints.first, let item = constraint.item as? UIView else { fatalError("Subscript to empty array of constraints") }
        return map { $0.to(constraint.itemAttribute, of: item) }
    }
    
    subscript(itemAttribute: LayoutAttribute) -> [PartialLayoutConstraint] {
        return map { $0.to(itemAttribute) }
    }
    
    subscript(item: LayoutItemShorthand) -> [PartialLayoutConstraint] {
        return map { $0.to(item) }
    }
}
