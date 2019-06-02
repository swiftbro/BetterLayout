//
//  Layout.swift
//  BetterLayout
//
//  Created by Vlad Che on 2/20/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

public protocol LayoutConstraint: StaticConstraintProvider {
    
    /// Returns NSLayoutConstraint
    ///
    /// - Parameters:
    ///   - view: view for the left side of the constraint (**NSLayoutConstraint.firstItem**)
    func `for`(_ view: UIView) -> NSLayoutConstraint
    
    // MARK: - Properties -
    
    /// The attribute of the view for the left side of the constraint.
    ///
    /// Will be tranlated to **NSLayoutConstraint.firstAttribute**
    /// - Important:
    ///     - Set with [ConstraintProvider](x-source-tag://ConstraintProvider) extension like **.top** or **.leading**
    ///     - Set with Int (Float, CGFloat, etc.) extension like **10.top**
    ///     - Set with [readable aliases](x-source-tag://ConstraintProvider) like **pin.top, just.below or exact.center**
    var attribute: LayoutAttribute {get}
    
    /// The attribute of the view for the right side of the constraint.
    ///
    /// Will be tranlated to **NSLayoutConstraint.secondAttribute**
    /// - Important:
    ///     - Most of time you don't need to set it explicitly. Coresponding attribute will be set automatically.
    ///     - For full control set it with
    ///         [func to(_ itemAttribute: LayoutAttribute, of view: UIView)](x-source-tag://toAttribute)
    var itemAttribute: LayoutAttribute {get}
    
    /// View or layout guide on the right side of the constraint.
    ///
    /// Will be tranlated to **NSLayoutConstraint.secondItem**
    /// - Important:
    ///     - Set UIView or UILayoutGuide as right item with [func to(_:)](x-source-tag://toView)
    var item: LayoutItem? {get}
    
    /// The constant added to the multiplied second attribute participating in the constraint.
    ///
    /// Will be tranlated to **NSLayoutConstraint.constant**
    /// - Important:
    ///     - Set with [func offset(by constant: Float)](x-source-tag://offset)
    ///     - Set with custom **+, -** operators like **.top+10** or **.bottom-20**
    ///     - Set with Int (Float, CGFloat, etc.) extension like **10.top** or **-20.bottom**
    ///     - Negate with [func negateConstant()](x-source-tag://negate) and custom **-** operator
    var constant: CGFloat {get}
    
    /// The multiplier applied to the second attribute participating in the constraint.
    ///
    /// Will be tranlated to **NSLayoutConstraint.multiplier**
    /// - Important:
    ///     - Set with [func multiply(_ multiplier: CGFloat)](x-source-tag://multiply)
    ///     - Set with custom __* and /__ operators like __someView.height / 2__
    var multiplier: CGFloat {get}
    
    /// The relation between the two attributes in the constraint.
    ///
    /// Will be tranlated to **NSLayoutConstraint.relation**
    /// - Important:
    ///     - Set with [func related(_ relation: LayoutRelation)](x-source-tag://related)
    ///     - Set with custom **≥ and ≤** (**Alt+>** and **Alt+<** on your keyboard) like **.top ≥ 10**
    ///     - Set with Int (Float, CGFloat, etc.) extension and **≥ or ≤** prefix like **≥10.top**
    var relation: LayoutRelation {get}
    
    /// The priority of the constraint.
    ///
    /// Will be tranlated to **NSLayoutConstraint.priority**
    /// - Important:
    ///     - Set with [func prioritized(by: Float)](x-source-tag://prioritized)
    ///     - Set with custom **~** operator like **.top~666**
    var priority: Float {get}
    
    /// Indicates that constraint protected from automatic attributes change
    ///
    /// Check [func changed(::)](x-source-tag://changeAttribute)
    var preserveAttributes: Bool {get}
    
    /// Will be called just before automatic changes and after NSLayoutConstraint construction
    var debugClosure: ((UIView, FullLayoutConstraint, NSLayoutConstraint?) -> Void)? {get}
}

/// UIView or UILayoutGuide
public protocol LayoutItem: class {}
extension UIView: LayoutItem {}
extension UILayoutGuide: LayoutItem {}

public extension Sequence where Element: LayoutConstraint {
    /// Returns NSLayoutConstraint for every layout constraint
    ///
    /// - Parameters:
    ///   - view: view for the left side of the constraint (**NSLayoutConstraint.firstItem**)
    func `for`(_ view: UIView) -> [NSLayoutConstraint] {
        return map { $0.for(view) }
    }
}
