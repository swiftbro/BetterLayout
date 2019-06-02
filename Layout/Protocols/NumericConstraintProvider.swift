//
//  NumericConstraintProvider.swift
//  BetterLayout
//
//  Created by Vlad Che on 3/26/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

public protocol FloatRepresentable {
    /// Float representation of number
    var value: Float { get }
}

public protocol NumericConstraintProvider: ConstraintProvider, ConstraintsCollection, FloatRepresentable
where Self.ProvidableConstraint == PartialLayoutConstraint, Self.ProvidableDimension == FullLayoutConstraint {
    
    /// Aspect ratio constraint
    ///
    /// Use it like:
    /// ```
    /// view.layout(2.aspectRatio) // where 2 is a multiplier
    /// ```
    /// Equals to:
    /// ```
    /// view.height = view.width * multiplier
    /// ```
    var aspectRatio: [FullLayoutConstraint] { get }
}

public extension NumericConstraintProvider {
    public var aspectRatio: [FullLayoutConstraint] {
        let partial = PartialLayoutConstraint(.height, 0, .width, true) * value
        return [FullLayoutConstraint(partial, to: nil)]
    }
}

extension Int: NumericConstraintProvider {
    public var value: Float { return Float(self) }
}

extension Float: NumericConstraintProvider {
    public var value: Float { return Float(self) }
}

extension CGFloat: NumericConstraintProvider {
    public var value: Float { return Float(self) }
}

extension Double: NumericConstraintProvider {
    public var value: Float { return Float(self) }
}

extension UInt: NumericConstraintProvider {
    public var value: Float { return Float(self) }
}
