//
//  FullLayoutConstraint.swift
//  BetterLayout
//
//  Created by Vlad Che on 3/16/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

public struct FullLayoutConstraint: LayoutConstraint, MutableLayoutConstraint {
    public let item: LayoutItem?
    public let itemDependent: Bool
    public private(set) var attribute: LayoutAttribute = .notAnAttribute
    public private(set) var itemAttribute: LayoutAttribute = .notAnAttribute
    public private(set) var constant: CGFloat = 0
    public private(set) var multiplier: CGFloat = 1.0
    public private(set) var relation: LayoutRelation = .equal
    public private(set) var priority: Float = .required
    public private(set) var debugClosure: ExpandedConstraintDebugClosure?
    public private(set) var preserveAttributes: Bool
    
    public func `for`(_ view: UIView) -> NSLayoutConstraint {
        view.translatesAutoresizingMaskIntoConstraints = false
        debugClosure?(view, self, nil)
        var changed = self.changed(for: view)
        changed.negateConstantIfNeeded()
        changed.changeRelationIfNeeded()
        let toItem = isAspectRatio ? view : changed.item
        
        let constraint = NSLayoutConstraint(item: view,
                                            attribute: changed.attribute,
                                            relatedBy: changed.relation,
                                            toItem: toItem,
                                            attribute: changed.toAttribute,
                                            multiplier: changed.multiplier,
                                            constant: changed.constant)
        
        constraint.priority = UILayoutPriority(rawValue:  changed.priority)
        debugClosure?(view, changed, constraint)
        return constraint
    }
    
    // MARK: - Init -
    
    public init(_ partial: PartialLayoutConstraint, to view: LayoutItem?, itemDependent: Bool = false) {
        attribute = partial.attribute
        itemAttribute = partial.itemAttribute
        item = view
        constant = partial.constant
        multiplier = partial.multiplier
        relation = partial.relation
        priority = partial.priority
        debugClosure = partial.debugClosure
        preserveAttributes = partial.preserveAttributes
        self.itemDependent = itemDependent
    }
}

extension FullLayoutConstraint: UpdatableLayoutConstraint {
    public func updated(_ change: ConstraintChange) -> FullLayoutConstraint {
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

extension FullLayoutConstraint: ConstraintsCollection {
    public func appending(constraints: [PartialLayoutConstraint]) -> [FullLayoutConstraint] {
        return self + constraints[self.item] + constant
    }
}

extension FullLayoutConstraint {
    
    /// Returns constraint with automatically changed attributes if item is superview or layout guide
    /// - Tag: changeAttribute
    /// - Parameters:
    ///   - view: view on the left side of constraint
    ///   - preserve: send true if attributes must be preserved
    fileprivate func changed(for view: UIView) -> FullLayoutConstraint {
        guard let toItem = item, !self.preserveAttributes else { return self }
        var shouldRevert: Bool = false
        if let toView = toItem as? UIView, //Revert if it's a constraint to superview
            view.isDescendant(of: toView) || toView.isDescendant(of: view) { shouldRevert = true }
        if toItem is UILayoutGuide { shouldRevert = true }
        var `self` = self
        if itemDependent {
            self.attribute = shouldRevert ? self.attribute.opposite : self.attribute
        } else {
            self.itemAttribute = shouldRevert ? self.itemAttribute.opposite : self.itemAttribute
        }
        return self
    }
    
    fileprivate mutating func negateConstantIfNeeded() {
        self.constant = attribute.needChanges ? -constant : constant
    }
    
    fileprivate mutating func changeRelationIfNeeded() {
        self.relation = attribute.needChanges ? relation.opposite : relation
    }
    
    fileprivate var isAspectRatio: Bool {
        return attribute == .height && itemAttribute == .width && item == nil && preserveAttributes
    }
    
    var toAttribute: LayoutAttribute {
        if preserveAttributes { return itemAttribute }
        return item == nil ? .notAnAttribute : itemAttribute
    }
}
