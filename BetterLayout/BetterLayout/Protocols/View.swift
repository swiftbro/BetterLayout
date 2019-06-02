//
//  View.swift
//  Trading
//
//  Created by Vladimir Kravchenko on 2/14/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit

typealias View = ResizableView & Setupable & Constrainable
typealias Cell = ResizableCell & Setupable & Constrainable
typealias Item = ResizableItem & Setupable & Constrainable

protocol Constrainable {
    /// Compact size specific constraints.
    /// Optional.
    var compactConstraints: [NSLayoutConstraint] {get}
    
    /// Regular size specific constraints.
    /// Optional.
    var regularConstraints: [NSLayoutConstraint] {get}
    
    func debugConstraints()
}

extension Constrainable {
    var compactConstraints: [NSLayoutConstraint] { return [] }
    var regularConstraints: [NSLayoutConstraint] { return [] }
    
    func reactivateConstraints() {
        guard let `self` = self as? UIView & Constrainable else { return }
        if self.isCompactHorizontal {
            if self.regularConstraints.isActive { NSLayoutConstraint.deactivate(self.regularConstraints) }
            NSLayoutConstraint.activate(self.compactConstraints)
        } else {
            if self.compactConstraints.isActive { NSLayoutConstraint.deactivate(self.compactConstraints) }
            NSLayoutConstraint.activate(self.regularConstraints)
        }
        debugConstraints()
    }
    
    func debugConstraints() { }
}

protocol Setupable {
    /// Internal method
    ///
    /// Add subviews and constraints. Called after init.
    func arrangeSubviews()
    
    /// Internal method
    ///
    /// Do additional setup like chanfing background color. Called after init.
    func setup()
}

/// Do not subclass directly. Instead use `View` typealias to require conforming `Constrainable` and `Setupable`
class ResizableView: UIView {
    
    //MARK: - Init
    
    convenience init() {
        self.init(frame: .screen)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doSetup()
    }
    
    fileprivate func doSetup() {
        backgroundColor = .view
        if let `self` = self as? Setupable {
            self.setup()
            self.arrangeSubviews()
        }
    }
    
    override class var requiresConstraintBasedLayout: Bool { return true }
    
    //MARK: - Constraints
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let `self` = self as? UIView & Constrainable else { return }
        self.reactivateConstraints()
    }
}

/// Do not subclass directly. Instead use `Cell` typealias to require conforming `Constrainable` and `Setupable`
class ResizableCell: UITableViewCell {
    
    //MARK: - Init
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        doSetup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doSetup()
    }
    
    fileprivate func doSetup() {
        if let `self` = self as? Setupable {
            backgroundColor = .view
            contentView.backgroundColor = .view
            selectedBackgroundView = UIView.with { $0.backgroundColor = #colorLiteral(red: 0, green: 0.2980392157, blue: 0.4980392157, alpha: 1) }
            self.setup()
            self.arrangeSubviews()
        }
    }
    
    override class var requiresConstraintBasedLayout: Bool { return true }
    
    //MARK: - Constraints
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let `self` = self as? UIView & Constrainable else { return }
        self.reactivateConstraints()
    }
}

/// Do not subclass directly. Instead use `Item` typealias to require conforming `Constrainable` and `Setupable`
class ResizableItem: UICollectionViewCell {
    
    //MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        doSetup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doSetup()
    }
    
    fileprivate func doSetup() {
        if let `self` = self as? Setupable {
            self.setup()
            self.arrangeSubviews()            
        }
    }
    
    override class var requiresConstraintBasedLayout: Bool { return true }
    
    //MARK: - Constraints
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let `self` = self as? UIView & Constrainable else { return }
        self.reactivateConstraints()
    }
}

extension CGRect {
    static var screen: CGRect { return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height) }
}
