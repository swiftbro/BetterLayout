//
//  PartialLayoutConstraint.swift
//  BetterLayout
//
//  Created by Vlad Che on 3/16/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit
 
public struct PartialLayoutConstraint: LayoutConstraint, MutableLayoutConstraint {
    public private(set) var itemShorthand: LayoutItemShorthand?
    
    public let item: LayoutItem? = nil
    public private(set) var attribute: LayoutAttribute = .notAnAttribute
    public private(set) var itemAttribute: LayoutAttribute = .notAnAttribute
    public private(set) var constant: CGFloat = 0
    public private(set) var multiplier: CGFloat = 1.0
    public private(set) var relation: LayoutRelation = .equal
    public private(set) var priority: Float = .required
    public private(set) var debugClosure: ExpandedConstraintDebugClosure?
    public private(set) var preserveAttributes: Bool
    
    public func `for`(_ view: UIView) -> NSLayoutConstraint {
        let shorthand = self.itemShorthand ?? .superview
        switch shorthand {
        case .superview: return FullLayoutConstraint(self, to: view.superview).for(view)
        case .safearea: return FullLayoutConstraint(self, to: view.superview?.safeAreaLayoutGuide).for(view)
        }
    }
    
    // MARK: - Init -
    
    /// Returns PartialLayoutConstraint object
    /// - Important:
    ///     - Most of time you **don't need to use this method**
    ///     - Check [ConstraintProvider](x-source-tag://ConstraintProvider) for quick constraints creation
    ///     - Set UIView or UILayoutGuide as right item with [func to(_:)](x-source-tag://toView)
    /// - Parameters:
    ///   - attribute:          The attribute of the view for the left side of the constraint
    ///                         Will be tranlated to **NSLayoutConstraint.firstAttribute**
    ///   - offset:             The constant added to the multiplied second attribute participating in the constraint
    ///                         Will be tranlated to **NSLayoutConstraint.constant**
    ///   - secondAttribute:    The attribute of the view for the right side of the constraint.
    ///                         Will be tranlated to **NSLayoutConstraint.secondAttribute**
    ///   - preserve:           By default *itemAttribute*
    ///                         will be changed to opposite if *view2* is a superview of *view1*,
    ///                         pass **true** if you want it to be unchanged
    public init(_ attribute: LayoutAttribute,
                _ offset: CGFloat,
                _ secondAttribute: LayoutAttribute? = nil,
                _ preserve: Bool = false) {
        self.attribute = attribute
        self.constant = offset
        self.itemAttribute = secondAttribute ?? attribute
        self.preserveAttributes = preserve
    }
    
    public var isDimensionConstraint: Bool {
        return attribute == .height || attribute == .width
    }
}

extension PartialLayoutConstraint: UpdatableLayoutConstraint {
    public func updated(_ change: ConstraintChange) -> PartialLayoutConstraint {
        var `self` = self
        switch change {
        case .offset(let c):        self.constant = CGFloat(c)
        case .negate:               self.constant = -self.constant
        case .multiplier(let m):    self.multiplier = m
        case .relation(let r):      self.relation = r
        case .priority(let p):      self.priority = p
        case .debug(let dc):        self.debugClosure = dc
        case .preserve:             self.preserveAttributes = true
        }
        return self
    }
}

extension PartialLayoutConstraint: ConstraintsCollection {
    public func appending(constraints: [PartialLayoutConstraint]) -> [PartialLayoutConstraint] {
        return self + constraints + constant
    }
}

extension PartialLayoutConstraint: ViewSettable {
    
    public var isMutable: Bool { return itemShorthand == nil }
    
    public func to(_ view: LayoutItem?) -> FullLayoutConstraint {
        return FullLayoutConstraint(self, to: view)
    }
    
    public func to(_ itemAttribute: LayoutAttribute, of view: UIView) -> FullLayoutConstraint {
        var `self` = self
        self.itemAttribute = itemAttribute
        self.preserveAttributes = true
        return FullLayoutConstraint(self, to: view)
    }
    
    public func to(_ itemAttribute: LayoutAttribute) -> PartialLayoutConstraint {
        var `self` = self
        self.itemAttribute = itemAttribute
        self.preserveAttributes = true
        self.itemShorthand = .superview
        return self
    }
    
    public func to(_ itemShorthand: LayoutItemShorthand) -> PartialLayoutConstraint {
        var `self` = self
        self.itemShorthand = itemShorthand
        return self
    }
}

extension Array where Element == PartialLayoutConstraint {
    @discardableResult
    func constraint(for views: UIView..., to view: UIView? = nil, active: Bool = true) -> [NSLayoutConstraint] {
        return views.flatMap { $0.constraint(self, to: view, active: active) }
    }
    
    @discardableResult
    func constraint(for views: UIView..., to guide: UILayoutGuide, active: Bool = true) -> [NSLayoutConstraint] {
        return views.flatMap { $0.constraint(self, to: guide, active: active) }
    }
    
    @discardableResult
    func constraint(for views: UIView..., to layoutItem: LayoutItemShorthand, active: Bool = true) -> [NSLayoutConstraint] {
        return views.flatMap { $0.constraint(self, to: layoutItem, active: active) }
    }
}
