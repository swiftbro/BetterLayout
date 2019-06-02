//
//  PartialConstrainable.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

public protocol PartialConstrainable {
    /// Set UIView or UILayoutGuide as second item of constraint
    /// - Tag: toView
    /// - Parameters:
    ///   - view:       View or layout guide on the right side of the constraint.
    ///                 Will be tranlated to **NSLayoutConstraint.secondItem**
    /// - Returns: Changed constraint
    func to(_ view: LayoutItem?) -> FullLayoutConstraint
    
    /// Set strict constraint to specified attribute of superview
    ///
    /// - Important: Be careful with creating an invalid constraint
    ///             (for example, view1.top == 0.0 x nil.notAnAttribute + 200.0
    ///             or view1.top == 1.0 x view2.height + 20.0)
    /// - Parameters:
    ///   - attribute: The attribute of the view for the right side of the constraint.
    ///                Will be tranlated to **NSLayoutConstraint.secondAttribute**
    /// - Returns: Changed constraint
    func to(_ itemAttribute: LayoutAttribute) -> PartialLayoutConstraint
    
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
    
    /// Set constraint to superview or safe area
    ///
    /// - Parameter itemShorthand: superview or safearea
    func to(_ itemShorthand: LayoutItemShorthand) -> PartialLayoutConstraint
}
