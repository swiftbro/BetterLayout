//
//  LayoutPercent.swift
//  BetterLayout
//
//  Created by Vlad Che on 2/24/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

public struct LayoutPercent {
    let value: Float
    var attribute: LayoutAttribute
    private var multiplier: Float { return value / 100.0 }
    
    public init(_ value: Float, attribute: LayoutAttribute = .notAnAttribute) {
        self.value = value
        self.attribute = attribute
    }
    
    public var width: LayoutPercent { return LayoutPercent(value, attribute: .width) }
    public var height: LayoutPercent { return LayoutPercent(value, attribute: .height) }
    
    public func to(_ itemAttribute: LayoutAttribute, of view: UIView) -> [FullLayoutConstraint] {
        var attribute = self.attribute
        if attribute == .notAnAttribute { attribute = itemAttribute }
        return [PartialLayoutConstraint(attribute, 0, itemAttribute, true).to(view) * multiplier]
    }
    
    public func of(_ view: UIView) -> [FullLayoutConstraint] {
        guard attribute != .notAnAttribute else { return view.width.height * multiplier }
        return [PartialLayoutConstraint(attribute, 0, attribute, true).to(view) * multiplier]
    }
    
    public subscript(view: UIView) -> [FullLayoutConstraint] {
        get { return self.of(view) }
    }
    
    subscript(constraints: [FullLayoutConstraint]) -> [FullLayoutConstraint] {
        get {
            guard
                let attribute = constraints.first?.itemAttribute,
                let view = constraints.first?.item as? UIView
                else { fatalError("Subscript to empty array is not supported") }
            return self.to(attribute, of: view)
        }
    }
}

postfix operator %

public postfix func % (value: Int) -> LayoutPercent {
    return LayoutPercent(Float(value))
}

public postfix func % (value: Float) -> LayoutPercent {
    return LayoutPercent(Float(value))
}

public postfix func % (value: CGFloat) -> LayoutPercent {
    return LayoutPercent(Float(value))
}

public postfix func % (value: Double) -> LayoutPercent {
    return LayoutPercent(Float(value))
}

public postfix func % (value: UInt) -> LayoutPercent {
    return LayoutPercent(Float(value))
}
