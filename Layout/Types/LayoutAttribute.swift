//
//  LayoutAttribute.swift
//  BetterLayout
//
//  Created by Vlad Che on 2/20/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

public typealias LayoutAttribute = NSLayoutConstraint.Attribute
public typealias LayoutRelation = NSLayoutConstraint.Relation

extension LayoutAttribute {
    var opposite: LayoutAttribute {
        switch self {
        case .top: return .bottom
        case .bottom: return .top
        case .leading: return .trailing
        case .trailing: return .leading
        case .left: return .right
        case .right: return .left
            
        //No changes for others
        default: return self
        }
    }
    
    var needChanges: Bool {
        return self == .bottom || self == .trailing || self == .right
    }
}

extension LayoutRelation {
    var opposite: LayoutRelation {
        switch self {
        case .lessThanOrEqual: return .greaterThanOrEqual
        case .equal: return .equal
        case .greaterThanOrEqual: return .lessThanOrEqual
        }
    }
}

extension LayoutAttribute: CustomStringConvertible {
    public var description: String {
        switch self {
        case .left: return "left"
        case .right: return "right"
        case .top: return "top"
        case .bottom: return "bottom"
        case .leading: return "leading"
        case .trailing: return "trailing"
        case .width: return "width"
        case .height: return "height"
        case .centerX: return "centerX"
        case .centerY: return "centerY"
        case .lastBaseline: return "lastBaseline"
        case .firstBaseline: return "firstBaseline"
        case .leftMargin: return "leftMargin"
        case .rightMargin: return "rightMargin"
        case .topMargin: return "topMargin"
        case .bottomMargin: return "bottomMargin"
        case .leadingMargin: return "leadingMargin"
        case .trailingMargin: return "trailingMargin"
        case .centerXWithinMargins: return "centerXWithinMargins"
        case .centerYWithinMargins: return "centerYWithinMargins"
        case .notAnAttribute: return "notAnAttribute"
        }
    }
}

extension LayoutRelation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .lessThanOrEqual: return "lessThanOrEqual"
        case .equal: return "equal"
        case .greaterThanOrEqual: return "greaterThanOrEqual"
        }
    }
}

public extension Float {
    public static var high: Float { return UILayoutPriority.defaultHigh.rawValue }
    public static var low: Float { return UILayoutPriority.defaultLow.rawValue }
    public static var required: Float { return UILayoutPriority.required.rawValue }
    public static var sizeLevel: Float { return UILayoutPriority.fittingSizeLevel.rawValue }
}
