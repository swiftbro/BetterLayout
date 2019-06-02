//
//  LayoutConstraint+CustomStringConvertible.swift
//  BetterLayout
//
//  Created by Vlad Che on 2/22/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

extension FullLayoutConstraint: CustomDebugStringConvertible, CustomStringConvertible {
    public var description: String {
        return debugDescription
    }
    
    public var debugDescription: String {
        var string = """
        
        ====== Constraint ======
        
        Constant: \(constant)
        
        First attribute: \(attribute)
        Second attribute: \(toAttribute)
        
        """
        string += toItemDescription
        string += """
        
        Priority: \(priority)
        Multiplier: \(multiplier)
        Relation: \(relation)
        
        """
        return string
    }
    
    public  func summary(for view: UIView) -> String {
        var description = """
        ======== Summary ========
        \(String(describing: type(of:view))).\(attribute)
        """
        if let toItem = item {
            description += " \(relationSign) \(toItem.debugName).\(itemAttribute) * \(multiplier) + \(constant)\n"
        } else {
            description += "\nwith constant \(constant)\n"
        }
        description += "========== End ==========\n"
        return description
    }
    
    var relationSign: String {
        switch relation {
        case .equal: return "="
        case .greaterThanOrEqual: return "≥"
        case .lessThanOrEqual: return "≤"
        }
    }
}

extension FullLayoutConstraint {
    var toItemDescription: String {
        var string = ""
        if let view = item as? UIView {
            string += "\nConstrained to UIView: \(view.debugName)\n"
            if let superview = view.superview {
                string += "Laying on: \(superview.debugName)\n"
            }
        }
        if let guide = item as? UILayoutGuide {
            string += "Constrained to layout guide: \(guide.debugName)\n"
        }
        return string
    }
}

public extension LayoutItem {
    public var debugName: String {
        if let guide = self as? UILayoutGuide {
            if let owningView = guide.owningView {
                return "\(owningView.debugName).\(guide.identifier)"
            } else {
                return "\(String(describing: type(of:self))).\(guide.identifier)"
            }
        }
        return String(describing: type(of:self))
    }
}
