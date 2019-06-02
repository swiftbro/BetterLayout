//
//  ViewExtensions.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

extension UITextField {
    var textPlaceholder: String? {
        get { return placeholder }
        set { attributedPlaceholder = NSAttributedString(string: newValue ?? " ", attributes: [.font: font!, .foregroundColor: textColor!]) }
    }
}

extension UIView {
    
    /// Adds views as subviews and returns itself
    ///
    /// - Parameter views: subviews to add
    /// - Returns: itself
    func with(_ views: UIView...) -> UIView {
        views.forEach(addSubview)
        return self
    }
    
    public convenience init<T>(_ setup: (T) -> Void) where T: UIView {
        self.init(frame: .screen)
        setup(self as! T)
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }
    
    static func with<T: UIView>(_ closure: (T) -> Void) -> T {
        let view = T()
        closure(view)
        return view
    }
    
    func fadeIn() {
        UIView.animate(withDuration: 0.2) { self.alpha = 1.0; self.isHidden = false }
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.2) { self.alpha = 0; self.isHidden = true }
    }
    
    var isCompactHorizontal: Bool {
        return traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular
    }
    
    func disableAutoresizing(recursive: Bool = true) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if recursive { subviews.forEach { $0.disableAutoresizing(recursive: recursive) } }
    }
    
    func hidden() -> Self {
        self.isHidden = true
        return self
    }
}

extension UIViewController {
    var `in`: ControllerContainer {
        return ControllerContainer(with: self)
    }
    
    func alert(_ message: String, title: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.ok)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func showError(_ error: Error) {
        alert(error.localizedDescription)
        error.print()
    }
}

struct ControllerContainer {
    private let controller: UIViewController
    init(with controller: UIViewController) {
        self.controller = controller
    }
    
    var navigatioController: UINavigationController {
        return UINavigationController(rootViewController: controller)
    }
    
    func split(with detail: UIViewController) -> UISplitViewController {
        let split = UISplitViewController()
        split.viewControllers = [controller, detail]
        split.tabBarItem = controller.tabBarItem
        return split
    }
}

extension UIAlertAction {
    static var ok: UIAlertAction {
        return UIAlertAction(title: "Ok", style: .default, handler: nil)
    }
    
    static var cancel: UIAlertAction {
        return UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
