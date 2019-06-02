//
//  UIControll+Action.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

extension UIControl {
    
    var hasAction: Bool { return getAssociatedObject(for: self, key: &closureTargetKey) != nil }
    
    /// Add action for control events with closure.
    /// Alternative to **addTarget(: action: for:)**
    /// - Parameters:
    ///   - controlEvents: A bitmask specifying the control-specific events for which the action method is called.
    ///                    Always specify at least one constant.
    ///   - exclusive:     If *true* previous action will be removed.
    ///   - closure:       Closure to be called when events occur.
    func addAction(for controlEvents: UIControl.Event, exclusive: Bool = true, _ closure: @escaping ()->()) {
        if exclusive { removeAction(for: controlEvents) }
        let target = ClosureTarget(closure)
        addTarget(target, action: target.action, for: controlEvents)
        setAssociatedObject(target, for: self, key: &closureTargetKey)
    }
    
    /// Remove action for control events
    ///
    /// - Parameter controlEvents: A bitmask specifying the control-specific events for which the action method is called.
    func removeAction(for controlEvents: UIControl.Event) {
        if let old = getAssociatedObject(for: self, key: &closureTargetKey) as? ClosureTarget {
            self.removeTarget(old, action: old.action, for: controlEvents)
        }
    }
}

extension UIButton {
    func addAction(exclusive: Bool = true, _ closure: @escaping ()->()) {
        addAction(for: .touchUpInside, exclusive: exclusive, closure)
    }
}

extension UIBarButtonItem {
    func addAction(_ closure: @escaping ()->()) {
        let target = ClosureTarget(closure)
        self.target = target
        self.action = target.action
        setAssociatedObject(target, for: self, key: &closureTargetKey)
    }
}

fileprivate class ClosureTarget {
    var action: Selector { return #selector(ClosureTarget.invoke) }
    private(set) var closure: ()->()
    init (_ closure: @escaping ()->()) { self.closure = closure }
    @objc func invoke () { closure() }
}

fileprivate var closureTargetKey: Void?
