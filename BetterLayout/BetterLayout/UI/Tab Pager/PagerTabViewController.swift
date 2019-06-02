//
//  PagerTabViewController.swift
//  Trading
//
//  Created by Vlad Che on 2/11/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PagerTabViewController: ButtonBarPagerTabStripViewController {
    
    var selectedViewController: UIViewController {
        return controllers[currentIndex]
    }
    
    func setViewControllers(_ controllers: [UIViewController]) {
        guard self.controllers != controllers else { return }
        self.controllers = controllers
        self.reloadPagerTabStripView()
    }
    
    //MARK: - Init
    
    init(with controllers: [UIViewController]) {
        self.controllers = controllers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("MarketController should be initialized with `init(with controllers:)` method")
    }
    
    // MARK: - Lifecycle
    
    override public func loadView() {
        let view = PagerTabView()
        buttonBarView = view.buttonsView
        containerView = view.scrollView
        self.view = view
    }
    
    override func viewDidLoad() {
        setupButtonsBar()
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return controllers
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    //MARK: - Private
    private(set) var controllers: [UIViewController]
    
    private func setupButtonsBar() {
        settings.style.buttonBarItemBackgroundColor = buttonBarView.backgroundColor
        settings.style.selectedBarBackgroundColor = UIColor.tab.highlighted
        settings.style.selectedBarHeight = 1
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor.tab.tint
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { oldCell, newCell, progress, changeCurrentIndex, animated in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.tab.tint
            newCell?.label.textColor = UIColor.tab.highlighted
        }
    }

}

extension UISplitViewController: TabPage {
    public var indicator: String {
        if let controller = self.viewControllers.first as? TabPage {
            return controller.indicator
        }
        return "No indicator"
    }
}
