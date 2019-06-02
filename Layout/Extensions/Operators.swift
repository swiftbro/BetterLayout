//
//  LayoutConstraintOperators.swift
//  BetterLayout
//
//  Created by Vlad Che on 2/20/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

prefix operator ≤
prefix operator ≥
prefix operator ≤-
prefix operator ≥-
infix operator ~: AdditionPrecedence
infix operator ≥: AdditionPrecedence
infix operator ≤: AdditionPrecedence
infix operator ≥-: AdditionPrecedence
infix operator ≤-: AdditionPrecedence
infix operator ^: AdditionPrecedence

public prefix func ≥ <T: MutableLayoutConstraint>(_ constraint: T) -> T.ConstraintType {
    return constraint.related(.greaterThanOrEqual)
}

public prefix func ≤ <T: MutableLayoutConstraint>(_ constraint: T) -> T.ConstraintType {
    return constraint.related(.lessThanOrEqual)
}

public prefix func ≥- <T: MutableLayoutConstraint>(_ constraint: T) -> T.ConstraintType {
    return -constraint.related(.greaterThanOrEqual)
}

public prefix func ≤- <T: MutableLayoutConstraint>(_ constraint: T) -> T.ConstraintType {
    return -constraint.related(.lessThanOrEqual)
}

public prefix func - <T: MutableLayoutConstraint>(_ constraint: T) -> T.ConstraintType {
    return constraint.negateConstant()
}

public extension MutableLayoutConstraint {
    
    public static func ≥ (lhs: Self, rhs: FloatRepresentable) -> ConstraintType {
        return lhs.offset(by: rhs.value).related(.greaterThanOrEqual)
    }
    
    public static func ≤ (lhs: Self, rhs: FloatRepresentable) -> ConstraintType {
        return lhs.offset(by: rhs.value).related(.lessThanOrEqual)
    }
    
    public static func ≥- (lhs: Self, rhs: FloatRepresentable) -> ConstraintType {
        return lhs.offset(by: -rhs.value).related(.greaterThanOrEqual)
    }
    
    public static func ≤- (lhs: Self, rhs: FloatRepresentable) -> ConstraintType {
        return lhs.offset(by: -rhs.value).related(.lessThanOrEqual)
    }
    
    public static func + (lhs: Self, rhs: FloatRepresentable) -> ConstraintType {
        return lhs.offset(by: rhs.value)
    }
    
    public static func - (lhs: Self, rhs: FloatRepresentable) -> ConstraintType {
        return lhs.offset(by: -rhs.value)
    }
    
    public static func ~ (lhs: Self, rhs: FloatRepresentable) -> ConstraintType {
        return lhs.prioritized(by: rhs.value)
    }
    
    public static func + (lhs: Self, rhs: Self) -> [Self] {
        return [lhs, rhs]
    }
    
    public static func + (lhs: Self, rhs: [Self]) -> [Self] {
        return [lhs] + rhs
    }
    
    public static func + (lhs: [Self], rhs: Self) -> [Self] {
        return lhs + [rhs]
    }
    
    public static func * (lhs: Self, rhs: FloatRepresentable) -> ConstraintType {
        return lhs.multiply(CGFloat(rhs.value))
    }
    
    public static func / (lhs: Self, rhs: FloatRepresentable) -> ConstraintType {
        return lhs.multiply(1.0 / CGFloat(rhs.value))
    }
}

extension Array where Element == PartialLayoutConstraint {
    public static func ^ (lhs: [PartialLayoutConstraint], rhs: LayoutItem) -> [FullLayoutConstraint] {
        return lhs[rhs]
    }
    
    public static func ^ (lhs: [PartialLayoutConstraint], rhs: [FullLayoutConstraint]) -> [FullLayoutConstraint] {
        return lhs[rhs]
    }
    
    public static func ^ (lhs: [PartialLayoutConstraint], rhs: LayoutAttribute) -> [PartialLayoutConstraint] {
        return lhs[rhs]
    }    
    
    public static func ^ (lhs: [PartialLayoutConstraint], rhs: LayoutItemShorthand) -> [PartialLayoutConstraint] {
        return lhs[rhs]
    }
}
