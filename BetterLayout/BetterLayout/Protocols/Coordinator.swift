//
//  Coordinator.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

typealias NavigationCoordinator = BaseNavigationCoordinator & Coordinator

protocol Coordinator: class, UINavigationControllerDelegate {
    var topViewController: UIViewController { get set }
}

extension Coordinator {
    
    /// Presents a view controller modally.
    ///
    /// Presenting view controller is a `topViewController`.
    /// It will be set to `viewController` parameter after transition.
    /// - Parameter viewController:
    ///     The view controller to display over the current view controller’s content.
    /// - Parameter animated:
    ///     Pass true to animate the presentation; otherwise, pass false.
    /// - Parameter completion:
    ///     The block to execute after the presentation finishes. This block has no return value and takes no parameters. You may specify nil for this parameter.
    func present(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        topViewController.present(viewController, animated: animated) { [unowned self] in
            self.topViewController = viewController
            completion?()
        }
    }
    
    /// Dismisses the view controller that was presented modally.
    ///
    /// `topViewController` will be set to it's `presentingViewController` after transition.
    /// - Parameter animated:
    ///     Pass true to animate the transition.
    /// - Parameter completion:
    ///     The block to execute after the view controller is dismissed. This block has no return value and takes no parameters. You may specify nil for this parameter.
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let presenter = topViewController.presentingViewController else { return }
        topViewController.dismiss(animated: animated) { [unowned self] in
            self.topViewController = presenter
            completion?()
        }
    }
}

class BaseNavigationCoordinator: NSObject {
    
    override init() {
        super.init()
        setDelegateIfNeeded()
    }
    
    // MARK: Private
    fileprivate var previousDelegate: UINavigationControllerDelegate?
    
    fileprivate var navigationController: UINavigationController? {
        guard let coordinator = self as? Coordinator else { return nil }
        guard let navigationController = coordinator.topViewController as? UINavigationController
            ?? coordinator.topViewController.navigationController else { return nil }
        return navigationController
    }
    
    fileprivate func setDelegateIfNeeded() {
        if let navigationController = navigationController {
            if navigationController.delegate !== self {
                previousDelegate = navigationController.delegate
                navigationController.delegate = self
            }
        }
    }
}

extension BaseNavigationCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if let coordinator = self as? Coordinator {
            coordinator.topViewController = viewController
        }
        previousDelegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
        previousDelegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop, let coordinator = self as? Coordinator {
            coordinator.topViewController = toVC
        }
        return previousDelegate?.navigationController?(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return previousDelegate?.navigationController?(navigationController, interactionControllerFor: animationController)
    }
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return UIDevice.isPhone ? .portrait : .landscape
    }
    
    func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        return UIDevice.isPhone ? .portrait : .landscapeLeft
    }
}

extension Coordinator where Self: BaseNavigationCoordinator {
    func show(_ viewController: UIViewController) {
        guard let navigationController = navigationController
            else { fatalError("Top view controller should be UINavigationController or be contained in navigation controller") }
        navigationController.interactivePopGestureRecognizer?.delegate = nil
        setDelegateIfNeeded()
        navigationController.show(viewController, sender: self)
    }
}
