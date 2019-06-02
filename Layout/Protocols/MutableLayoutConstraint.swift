//
//  MutableLayoutConstraint.swift
//  BetterLayout
//
//  Created by Vlad Che on 3/25/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

public typealias ConstraintDebugClosure = (FullLayoutConstraint) -> Void
public typealias ExpandedConstraintDebugClosure = (UIView, FullLayoutConstraint, NSLayoutConstraint?) -> Void

public protocol MutableLayoutConstraint where Self.ConstraintType == Self.ConstraintType.ConstraintType {
    
    associatedtype ConstraintType: MutableLayoutConstraint
    
    // MARK: - Functions -
    
    /// Set constant to constraint
    /// - Tag: offset
    /// - Parameter constant: The constant added to the multiplied second attribute participating in the constraint.
    ///                       Will be tranlated to **NSLayoutConstraint.constant**
    /// - Returns: Changed constraint
    func offset(by constant: Float) -> ConstraintType
    
    /// Negates constant value
    /// - Tag: negate
    /// - Returns: Changed constraint
    func negateConstant() -> ConstraintType
    
    /// Set multiplier property to constraint
    /// - Tag: multiply
    /// - Parameter multiplier: The multiplier applied to the second attribute participating in the constraint.
    ///                         Will be tranlated to **NSLayoutConstraint.multiplier**
    /// - Returns: Changed constraint
    func multiply(_ multiplier: CGFloat) -> ConstraintType
    
    /// Set relation property to constraint
    /// - Tag: related
    /// - Parameter relation: The relation between the two attributes in the constraint.
    ///                       Will be tranlated to **NSLayoutConstraint.relation**
    /// - Returns: Changed constraint
    func related(_ relation: LayoutRelation) -> ConstraintType
    
    /// Set priority to constraint
    /// - Tag: prioritized
    /// - Parameter by: The priority of the constraint.
    ///                 See [UILayoutPriority](https://developer.apple.com/documentation/uikit/uilayoutpriority) for details.
    ///                 Will be translated to **NSLayoutConstraint.priority**
    /// - Returns: Changed constraint
    func prioritized(by: Float) -> ConstraintType
    
    /// Will print detailed info about constraint.
    ///
    /// Closure will be called just before NSLayoutConstraint construction
    /// - Parameter closure: optional closure for breakpoint and debug
    /// - Returns: same layout constraint
    func debug(_ closure: ConstraintDebugClosure?) -> ConstraintType
    
    /// Returns same constraint protected from automatic attributes change
    var preserved: ConstraintType {get}
}


