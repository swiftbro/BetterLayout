//
//  UpdatableLayoutConstraint.swift
//  Trading
//
//  Created by Vladimir Kravchenko on 3/28/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit

public protocol UpdatableLayoutConstraint {
    associatedtype T
    func updated(_ change: ConstraintChange) -> T
}

public enum ConstraintChange {
    case offset(Float)
    case negate
    case multiplier(CGFloat)
    case relation(LayoutRelation)
    case priority(Float)
    case debug(ExpandedConstraintDebugClosure)
    case preserve
}

extension UpdatableLayoutConstraint where Self: MutableLayoutConstraint, Self.T == Self.ConstraintType {
    public func offset(by c: Float) -> T                        { return updated(.offset(c)) }
    public func negateConstant() -> T                           { return updated(.negate) }
    public func multiply(_ m: CGFloat) -> T                     { return updated(.multiplier(m)) }
    public func related(_ r: LayoutRelation) -> T               { return updated(.relation(r)) }
    public func prioritized(by: Float) -> T                     { return updated(.priority(by)) }
    public func debug(_ c: ConstraintDebugClosure? = nil) -> T  { return updated(.debug(with(c))) }
    public var  preserved: T                                    { return updated(.preserve) }
    
    private func with(_ closure: ConstraintDebugClosure?) -> ExpandedConstraintDebugClosure {
        return { view, constraint, nsLayoutConstraint in
            if nsLayoutConstraint != nil {
                debugPrint(constraint)
                print(constraint.summary(for: view))
            }
            closure?(constraint)
        }
    }
}

extension Array: UpdatableLayoutConstraint where Element: UpdatableLayoutConstraint {
    public typealias T = Array<Element.T>
    public func updated(_ change: ConstraintChange) -> Array<Element.T> {
        return map { $0.updated(change) }
    }
}

extension Array: MutableLayoutConstraint
where Element: UpdatableLayoutConstraint & MutableLayoutConstraint & LayoutConstraint,
      Element == Element.ConstraintType, Element == Element.T {
    public typealias ConstraintType = [Element]
}
