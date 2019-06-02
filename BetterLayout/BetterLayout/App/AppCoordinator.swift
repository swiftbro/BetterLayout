//
//  AppCoordinator.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

class AppCoordinator: NavigationCoordinator {
    lazy var topViewController: UIViewController = tabBarController.in.navigatioController
    private let window: UIWindow
    
    /// Initializes and returns a newly allocated object with the specified window
    /// - Parameter window: window object to set up
    /// - Important: call **setup** to make window key and visible
    init(with window: UIWindow) {
        self.window = window
        super.init()
    }
    
    func setup() {
        window.rootViewController = topViewController
        topViewController.navigationController?.delegate = self
        window.makeKeyAndVisible()
        setupAppearance()
    }
    
    //MARK: - Private
    private lazy var factory = TabBarFactory(with: self)
    private lazy var tabBarController = UIDevice.isPhone
        ? factory.tabBar(with: [marketController, portfolioController, searchController])
        : factory.tabBar(with: [portfolioController, marketController, searchController])
    
    private lazy var marketController = UIDevice.isPhone
        ? factory.market(with: [todayController, cryptocurrenciesController, stocksController, forexController])
        : factory.market(with: [watchlistController, cryptocurrenciesController, stocksController, forexController].map(split))
    
    private lazy var portfolioController = UIDevice.isPhone
        ? factory.portfolio(with: [myportfolioController, watchlistController])
        : myportfolioController.in.split(with: todayController)
    
    private lazy var searchController = UIDevice.isPhone
        ? factory.search
        : factory.search.in.split(with: itemDetailsEmpty)
    
    private lazy var todayController = factory.today
    private lazy var analyticsController = factory.analytics
    private lazy var cryptocurrenciesController = factory.cryptocurrencies
    private lazy var stocksController = factory.stocks
    private lazy var forexController = factory.forex
    private lazy var myportfolioController = factory.myPortfolio
    private lazy var watchlistController = factory.watchList
    
    private var itemDetailsEmpty: UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .view
        let activity = UIActivityIndicatorView(style: .whiteLarge)
        controller.view.addSubview(activity)
        activity.layout(.center)
//        activity.startAnimating()
        return controller
    }
    
    private func split(_ controller: UIViewController) -> UISplitViewController {
         return controller.in.split(with: itemDetailsEmpty)
    }
    
    private lazy var testMode = factory.testMode
    
    private func setupAppearance() {
        AttributedParameters.default.set(font: .medium, color: .white, space: 1.3)
        let navigationBar = UINavigationBar.appearance()
        navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back")
        navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back")
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.barTintColor = #colorLiteral(red:0.02, green:0.17, blue:0.36, alpha:1)        
        navigationBar.titleTextAttributes = [
            .font: .semibold-20,
            .foregroundColor: UIColor.white,
            .paragraphStyle: NSParagraphStyle.with { $0.lineSpacing = 1.2 },
        ]
    }
}

extension AppCoordinator: TodayCoordinator {
    var watchlist: Watchlist<MarketItem> { return SavedEquities.list }    
    var portfolio: Watchlist<MarketItem> { return Portfolio.list }
    
    func stopTransitions() {
        marketController.containerView?.isScrollEnabled = false
    }
    
    func resumeTransitions() {
        marketController.containerView?.isScrollEnabled = true
    }
    
    func showPortfolio() {
        if let portfolioController = portfolioController as? PagerTabViewController, UIDevice.isPhone {
            tabBarController.setSelectIndex(from: tabBarController.selectedIndex, to: 1)
            portfolioController.moveTo(viewController: myportfolioController, animated: false)
        }
    }
    
    func showSearch() {
        tabBarController.setSelectIndex(from: tabBarController.selectedIndex, to: 2)
    }
    
    func showAnalytics() {
        if Portfolio.list.items.isEmpty {
            topViewController.alert("Add items to portfolio first")
        } else {
            show(analyticsController)            
        }
    }
    
    func isWatching(_ item: MarketItem) -> Bool {
        return SavedEquities.contains(item)
    }
    
    func watch(_ item: MarketItem) {
        if isWatching(item) {
            SavedEquities.remove(item)
        } else {
            SavedEquities.add(item)
        }
    }
    
    func canSell(_ item: MarketItem) -> Bool {
        return Portfolio.amount(of: item) > 0
    }
    
    func sell(_ item: MarketItem) {
        let viewModel = BuySellViewModel(with: item, operation: .sell)
        let viewController = BuySellViewController(with: viewModel)
        show(viewController)
    }
    
    func buy(_ item: MarketItem) {
        let viewModel = BuySellViewModel(with: item, operation: .buy)
        let viewController = BuySellViewController(with: viewModel)
        show(viewController)
    }
}

extension AppCoordinator: SearchCoordinator {
    func show(_ item: MarketItem, from presenter: UIViewController) {
        let viewModel = TodayViewModel(portfolio: Watchlist(items: [item]))
        let controller = TodayViewController(with: viewModel, coordinator: self)
        if UIDevice.isPad, let split = presenter.splitViewController {
            split.showDetailViewController(controller, sender: presenter)
        } else {
            show(controller)
        }
    }
}

extension AppCoordinator: WatchlistCoordinator {
    func showEmptyDetails(for controller: UIViewController) {
        guard UIDevice.isPad, let split = controller.splitViewController else { return }
        let details = controller is WatchlistViewController ? todayController : itemDetailsEmpty
        split.showDetailViewController(details, sender: controller)
    }
    
    func detailsIsEmpty(for controller: UIViewController) -> Bool {
        guard   UIDevice.isPad,
                let split = controller.splitViewController,
                let details = split.viewControllers.last,
                details is TodayViewController
                else { return false }
        return true
    }
}

extension AppCoordinator: TestModeCoordinator {
    func showTestMode() {
        let controller = testMode.in.navigatioController
        controller.transitioningDelegate = testMode
        controller.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissTestMode))
        tap.delegate = self
        testMode.view.addGestureRecognizer(tap)
        present(controller, animated: true, completion: nil)
    }
    
    @objc func dismissTestMode() {
        dismiss(animated: true, completion: nil)
    }
}

extension AppCoordinator: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UIControl)
    }
}
