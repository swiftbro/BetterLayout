//
//  LayoutConstraintToAlternatives.swift
//  BetterLayout
//
//  Created by Vlad Che on 2/21/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

public extension ViewSettable {
    /// Alternative to [func to(_ view: UIView)](x-source-tag://toView) for readability.
    ///
    /// Use it when appropriate, for example:
    /// ```
    /// view.layout(just.below.the(bar))
    /// ```
    /// - Parameters:
    ///   - view:       View or UILayoutGuide on the right side of the constraint.
    ///                 Will be tranlated to **NSLayoutConstraint.secondItem**
    /// - Returns: Changed constraint
    public func the(_ item: LayoutItem) -> FullLayoutConstraint {
        return to(item)
    }
    
    /// Alternative to [func to(_ view: UIView)](x-source-tag://toView) for readability.
    ///
    /// Use it when appropriate, for example:
    /// ```
    /// view.layout(10.top.from(bar))
    /// ```
    /// - Parameters:
    ///   - view:       View or UILayoutGuide on the right side of the constraint.
    ///                 Will be tranlated to **NSLayoutConstraint.secondItem**
    /// - Returns: Changed constraint
    public func from(_ item: LayoutItem) -> FullLayoutConstraint {
        return to(item)
    }
    
    /// Alternative to [func to(_ view: UIView)](x-source-tag://toView) for readability.
    ///
    /// Use it when appropriate, for example:
    /// ```
    /// label.layout(exact.center.of(contentView))
    /// ```
    /// - Parameters:
    ///   - view:       View or UILayoutGuide on the right side of the constraint.
    ///                 Will be tranlated to **NSLayoutConstraint.secondItem**
    /// - Returns: Changed constraint
    public  func of(_ item: LayoutItem) -> FullLayoutConstraint {
        return to(item)
    }
}

public extension Sequence where Element: ViewSettable {
    /// Alternative to [func to(_ view: UIView)](x-source-tag://toViewArray) for readability.
    ///
    /// Use it when appropriate, for example:
    /// ```
    /// view.layout(just.below.the(bar))
    /// ```
    /// - Parameters:
    ///   - item:       View or UILayoutGuide on the right side of the constraint.
    ///                 Will be tranlated to **NSLayoutConstraint.secondItem**
    /// - Returns: Changed constraints
    public func the(_ item: LayoutItem) -> [FullLayoutConstraint] {
        return to(item)
    }
    
    /// Alternative to [func to(_ view: UIView)](x-source-tag://toViewArray) for readability.
    ///
    /// Use it when appropriate, for example:
    /// ```
    /// view.layout(10.top.from(bar))
    /// ```
    /// - Parameters:
    ///   - item:       View or UILayoutGuide on the right side of the constraint.
    ///                 Will be tranlated to **NSLayoutConstraint.secondItem**
    /// - Returns: Changed constraints
    public func from(_ item: LayoutItem) -> [FullLayoutConstraint] {
        return to(item)
    }
    
    /// Alternative to [func to(_ view: UIView)](x-source-tag://toViewArray) for readability.
    ///
    /// Use it when appropriate, for example:
    /// ```
    /// label.layout(exact.center.of(contentView))
    /// ```
    /// - Parameters:
    ///   - view:       View or UILayoutGuide on the right side of the constraint.
    ///                 Will be tranlated to **NSLayoutConstraint.secondItem**
    /// - Returns: Changed constraints
    public func of(_ item: LayoutItem) -> [FullLayoutConstraint] {
        return to(item)
    }
}
