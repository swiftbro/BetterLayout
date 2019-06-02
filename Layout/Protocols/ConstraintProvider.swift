//
//  ConstrainProvider.swift
//  BetterLayout
//
//  Created by Vlad Che on 2/20/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

public var just: Int { return 0 }
public var zero: Int { return 0 }
public var exact: Int { return 0 }

/// Protocol for quick layout constraints creation.
/// - Tag: ConstraintProvider
/// - Important:
///     - Extends **Int, UInt, Float, Double, CGFloat**
///       so can be used on this types like:
///       ```
///       view.layout(10.top, 10.bottom)
///       ```
///     - Implemented for **LayoutConstraint** with static properties:
///       ```
///       view.layout(.top, .bottom, to: superview)
///       ```
///     - Implemented for **LayoutConstraint arrays** for chaining:
///       ```
///       view.layout(10.top.bottom)
///       ```
///     - Can be used with readable aliases:
///       ```
///       view.layout(
///         just.below.the(label) +
///         exact.center.of(superview) +
///         pin.leading.trailing, to: .safearea
///       )
///       ```
public protocol ConstraintProvider {
    
    //MARK: - Dimensions -
    
    /// Layout constraint for width
    var width: [ProvidableDimension] { get }
    
    /// Layout constraint for height
    var height: [ProvidableDimension] { get }
    
    //MARK: - Anchors -
    
    /// Layout constraint
    ///
    /// **Attributes**
    /// - For views on the same superview: `myView.top` - `otherView.bottom`
    /// - For descendant views: `myView.top` - `superview.top`
    var top: [ProvidableConstraint] { get }
    
    /// Layout constraint
    ///
    /// **Attributes**
    /// - For views on the same superview: `myView.leading` - `otherView.trailing`
    /// - For descendant views: `myView.leading` - `superview.leading`
    var leading: [ProvidableConstraint] { get }
    
    /// Layout constraint
    ///
    /// **Attributes**
    /// - For views on the same superview: `myView.bottom` - `otherView.top`
    /// - For descendant views: `myView.bottom` - `superview.bottom`
    var bottom: [ProvidableConstraint] { get }
    
    /// Layout constraint
    ///
    /// **Attributes**
    /// - For views on the same superview: `myView.trailing` - `otherView.leading`
    /// - For descendant views: `myView.trailing` - `superview.trailing`
    var trailing: [ProvidableConstraint] { get }
    
    /// Layout constraint
    ///
    /// **Attributes**
    /// - For views on the same superview: `myView.left` - `otherView.right`
    /// - For descendant views: `myView.left` - `superview.left`
    var left: [ProvidableConstraint] { get }
    
    /// Layout constraint
    ///
    /// **Attributes**
    /// - For views on the same superview: `myView.right` - `otherView.left`
    /// - For descendant views: `myView.right` - `superview.right`
    var right: [ProvidableConstraint] { get }
    
    //MARK: - Prepositions -
    
    /// Layout constraint
    ///
    /// **Attributes**
    /// - For views on the same superview: `myView.bottom` - `otherView.top`
    /// - For descendant views: `myView.bottom` - `superview.top`
    var above: [ProvidableConstraint] { get }
    
    /// Layout constraint
    ///
    /// **Attributes**
    /// - For views on the same superview: `myView.top` - `otherView.bottom`
    /// - For descendant views: `myView.top` - `superview.bottom`
    var below: [ProvidableConstraint] { get }
    
    /// Layout constraint
    ///
    /// **Attributes**
    /// - For views on the same superview: `myView.trailing` - `otherView.leading`
    /// - For descendant views: `myView.trailing` - `superview.leading`
    var before: [ProvidableConstraint] { get }
    
    /// Layout constraint
    ///
    /// **Attributes**
    /// - For views on the same superview: `myView.leading` - `otherView.trailing`
    /// - For descendant views: `myView.leading` - `superview.trailing`
    var after: [ProvidableConstraint] { get }
    
    //MARK: - Center -
    
    /// Layout constraint for centerX and centerY
    var center: [ProvidableConstraint] { get }
    
    /// Layout constraint that centers along the x-axis
    var centerX: [ProvidableConstraint] { get }
    
    /// Layout constraint that centers along the y-axis
    var centerY: [ProvidableConstraint] { get }
    
    //MARK: - Edges -
    
    /// Layout constraint for top, bottom, leading, trailing
    var edges: [ProvidableConstraint] { get }
    
    /// Layout constraint
    ///
    /// **Attributes**
    /// - For views on the same superview: `myView.top` - `otherView.top`
    /// - For descendant views: `myView.top` - `superview.top`
    var topEdge: [ProvidableConstraint] { get }
    
    /// Layout constraint
    ///
    /// **Attributes**
    /// - For views on the same superview: `myView.leading` - `otherView.leading`
    /// - For descendant views: `myView.leading` - `superview.leading`
    var leadingEdge: [ProvidableConstraint] { get }
    
    /// Layout constraint
    ///
    /// **Attributes**
    /// - For views on the same superview: `myView.bottom` - `otherView.bottom`
    /// - For descendant views: `myView.bottom` - `superview.bottom`
    var bottomEdge: [ProvidableConstraint] { get }
    
    /// Layout constraint
    ///
    /// **Attributes**
    /// - For views on the same superview: `myView.trailing` - `otherView.trailing`
    /// - For descendant views: `myView.trailing` - `superview.trailing`
    var trailingEdge: [ProvidableConstraint] { get }
    
    associatedtype ProvidableConstraint: MutableLayoutConstraint & LayoutConstraint where Self.ProvidableConstraint == Self.ProvidableConstraint.ConstraintType
    associatedtype ProvidableDimension: MutableLayoutConstraint & LayoutConstraint where Self.ProvidableDimension == Self.ProvidableDimension.ConstraintType
}

extension UIView: ConstraintProvider {
    public typealias ProvidableConstraint = FullLayoutConstraint
    public typealias ProvidableDimension = FullLayoutConstraint
}

extension UILayoutGuide: ConstraintProvider {
    public typealias ProvidableConstraint = FullLayoutConstraint
    public typealias ProvidableDimension = FullLayoutConstraint
}

extension PartialLayoutConstraint: ConstraintProvider {
    public typealias ProvidableConstraint = PartialLayoutConstraint
    public typealias ProvidableDimension = PartialLayoutConstraint
}

extension FullLayoutConstraint: ConstraintProvider {
    public typealias ProvidableConstraint = FullLayoutConstraint
    public typealias ProvidableDimension = FullLayoutConstraint
}



