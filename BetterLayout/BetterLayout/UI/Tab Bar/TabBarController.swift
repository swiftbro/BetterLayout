//
//  TabBarController.swift
//  Trading
//
//  Created by Vlad Che on 2/11/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class TabBarController: RAMAnimatedTabBarController, UITabBarControllerDelegate {
    var coordinator: AppCoordinator!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = UIColor.tab.back
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        changeSelectedColor(UIColor.tab.highlighted, iconSelectedColor: UIColor.tab.highlighted)
        bottomLineWidth = 75
        bottomLineHeight = 1
        bottomLineColor = UIColor.tab.highlighted
        isBottomLineShow = true
        navigationItem.title = selectedViewController?.navigationItem.title
        delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        navigationItem.title = viewController.navigationItem.title
    }
    
    override var bottomLineOffset: CGFloat {
        get { if UIDevice.isX { return -10 } else { return 3 } }
        set { print("Set bottomLineOffset is not available") }
    }
    
    // MARK: - Shake
    
    override var canBecomeFirstResponder: Bool { return true }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        resignFirstResponder()
        super.viewWillDisappear(animated)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            coordinator.showTestMode()
        }
    }

}

class TabBarItem: RAMAnimatedTabBarItem {
    
    override init() {
        super.init()
        iconColor = UIColor.tab.tint
        textColor = UIColor.tab.tint
        textFontSize = 11
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override var animation: RAMItemAnimation! {
        get { return defaultAnimation }
        set { print("Set animation is not available") }
    }
    
    override var yOffSet: CGFloat {
        get {
            if UIDevice.isX { return -5 } else { return 3 } }
        set { print("Set yOffSet is not available") }
    }
    
    override var iconView: (icon: UIImageView, textLabel: UILabel)? {
        get {
            guard let icon = imageView, let label = label else { return super.iconView }
            return super.iconView ?? (icon, label)
        }
        set { super.iconView = newValue }
    }
    
    override func titleTextAttributes(for state: UIControl.State) -> [NSAttributedString.Key : Any]? {
        let paragraphStyle = NSParagraphStyle.with{ $0.lineSpacing = 1.27 }
        let font = .medium-11
        return [.font: font, .paragraphStyle: paragraphStyle]
    }
    
    private var defaultAnimation: RAMItemAnimation = RAMRotationAnimation()
    
    private var label: UILabel? {
        guard let title = title, let attributes = titleTextAttributes(for: .normal) else { return nil }
        let label = UILabel(frame: .zero)
        let text = NSAttributedString(string: title, attributes: attributes)
        label.attributedText = text
        label.sizeToFit()
        return label
    }
    
    private var imageView: UIImageView? {
        guard let image = self.image else { return nil }
        return UIImageView(image: image, highlightedImage: selectedImage)
    }
}
