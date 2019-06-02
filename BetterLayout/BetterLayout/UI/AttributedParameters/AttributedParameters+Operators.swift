//
//  AttributedParameters+Operators.swift
//  Trading
//
//  Created by Vladimir Kravchenko on 3/15/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit

fileprivate protocol AttributedParametersProvider {
    var _attributedParams: AttributedParameters {get}
}

extension AttributedParameters: AttributedParametersProvider {
    
    fileprivate var _attributedParams: AttributedParameters { return self }
    
    static func + (lhs: AttributedParameters, rhs: AttributedParameters) -> AttributedParameters {
        return AttributedParameters(update: rhs.update,
                                    text: rhs.text ?? lhs.text,
                                    font: rhs.font ?? lhs.font,
                                    color: rhs.color ?? lhs.color,
                                    align: rhs.align ?? lhs.align,
                                    lines: rhs.lines ?? lhs.lines,
                                    space: rhs.space ?? lhs.space,
                                    kern: rhs.kern ?? lhs.kern)
    }
    
    static func + (lhs: AttributedParameters, rhs: UIFont) -> AttributedParameters {
        return lhs._attributedParams + rhs._attributedParams
    }
    static func + (lhs: AttributedParameters, rhs: UIColor) -> AttributedParameters {
        return lhs._attributedParams + rhs._attributedParams
    }
    static func + (lhs: AttributedParameters, rhs: NSTextAlignment) -> AttributedParameters {
        return lhs._attributedParams + rhs._attributedParams
    }
    static func + (lhs: AttributedParameters, rhs: String) -> AttributedParameters {
        return lhs._attributedParams + rhs._attributedParams
    }
}

extension String: AttributedParametersProvider {
    
    fileprivate var _attributedParams: AttributedParameters { return AttributedParameters(text: self) }
    
    static func + (lhs: String, rhs: AttributedParameters) -> AttributedParameters {
        return lhs._attributedParams + rhs._attributedParams
    }
    static func + (lhs: String, rhs: UIFont) -> AttributedParameters {
        return lhs._attributedParams + rhs._attributedParams
    }
    static func + (lhs: String, rhs: UIColor) -> AttributedParameters {
        return lhs._attributedParams + rhs._attributedParams
    }
    static func + (lhs: String, rhs: NSTextAlignment) -> AttributedParameters {
        return lhs._attributedParams + rhs._attributedParams
    }
}

extension UIFont: AttributedParametersProvider {
    
    fileprivate var _attributedParams: AttributedParameters { return AttributedParameters(font: self) }
    
    static func + (lhs: UIFont, rhs: AttributedParameters) -> AttributedParameters {
        return lhs._attributedParams + rhs._attributedParams
    }
    static func + (lhs: UIFont, rhs: UIColor) -> AttributedParameters {
        return lhs._attributedParams + rhs._attributedParams
    }
    static func + (lhs: UIFont, rhs: NSTextAlignment) -> AttributedParameters {
        return lhs._attributedParams + rhs._attributedParams
    }
    static func + (lhs: UIFont, rhs: String) -> AttributedParameters {
        return lhs._attributedParams + rhs._attributedParams
    }
}

extension UIColor: AttributedParametersProvider {
    
    fileprivate var _attributedParams: AttributedParameters { return AttributedParameters(color: self) }
    
    static func + (lhs: UIColor, rhs: AttributedParameters) -> AttributedParameters {
        return lhs._attributedParams + rhs._attributedParams
    }
    static func + (lhs: UIColor, rhs: UIFont) -> AttributedParameters {
        return lhs._attributedParams + rhs._attributedParams
    }
    static func + (lhs: UIColor, rhs: NSTextAlignment) -> AttributedParameters {
        return lhs._attributedParams + rhs._attributedParams
    }
    static func + (lhs: UIColor, rhs: String) -> AttributedParameters {
        return lhs._attributedParams + rhs._attributedParams
    }
}

extension NSTextAlignment: AttributedParametersProvider {
    
    fileprivate var _attributedParams: AttributedParameters { return AttributedParameters(align: self) }
    
    static func + (lhs: NSTextAlignment, rhs: AttributedParameters) -> AttributedParameters {
        return lhs._attributedParams + rhs._attributedParams
    }
    static func + (lhs: NSTextAlignment, rhs: UIFont) -> AttributedParameters {
        return lhs._attributedParams + rhs._attributedParams
    }
    static func + (lhs: NSTextAlignment, rhs: UIColor) -> AttributedParameters {
        return lhs._attributedParams + rhs._attributedParams
    }
    static func + (lhs: NSTextAlignment, rhs: String) -> AttributedParameters {
        return lhs._attributedParams + rhs._attributedParams
    }
}
