//
//  TabBarFactory.swift
//  Trading
//
//  Created by Vladimir Kravchenko on 2/15/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit
import XLPagerTabStrip

struct TabBarFactory {
    private unowned let coordinator: AppCoordinator
    
    init(with coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    func tabBar(with controllers: [UIViewController]) -> TabBarController {
        let controller = TabBarController()
        controller.coordinator = coordinator
        controller.setViewControllers(controllers, animated: false)
        return controller
    }
    
    func wrapInNavigationController(_ controller: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.tabBarItem = controller.tabBarItem
        return navigationController
    }
    
    func market(with controllers: [UIViewController]) -> PagerTabViewController {
        let controller = PagerTabViewController(with: controllers)
        controller.tabBarItem = TabBarItem(title: L.Tab.market,
                                           image: Bundle.current.image(#imageLiteral(resourceName: "market")),
                                           selectedImage: Bundle.current.image(#imageLiteral(resourceName: "a_market")))
        controller.navigationItem.title = L.Tab.market
        return controller
    }
    
    func portfolio(with controllers: [UIViewController]) -> PagerTabViewController {
        let controller = PagerTabViewController(with: controllers)
        controller.tabBarItem = TabBarItem(title: L.Tab.portfolio,
                                           image: Bundle.current.image(#imageLiteral(resourceName: "portfolio")),
                                           selectedImage: Bundle.current.image(#imageLiteral(resourceName: "a_portfolio")))
        controller.navigationItem.title = L.Tab.portfolio
        return controller
    }
    
    var search: SearchViewController {
        let suggestions = Watchlist(items: list(for: .stocks).items
                                    + list(for: .cryptocurrensies).items
                                    + list(for: .forex).items)
        let viewModel = SearchViewModel(with: SavedEquities.list, suggestions: suggestions)
        let controller = SearchViewController(with: viewModel, coordinator: coordinator)
        controller.tabBarItem = TabBarItem(title: L.Tab.search,
                                           image: Bundle.current.image(#imageLiteral(resourceName: "search")),
                                           selectedImage: Bundle.current.image(#imageLiteral(resourceName: "a_search")))
        return controller
    }
    
    private let portfolioViewModel = TodayViewModel(portfolio: Portfolio.list)
    
    var today: TodayViewController {
        let controller = TodayViewController(with: portfolioViewModel, coordinator: coordinator)
        return controller
    }
    
    var analytics: AnalyticsViewController {
        let controller = AnalyticsViewController(with: portfolioViewModel)
        return controller
    }
    
    var myPortfolio: WatchlistViewController {
        let controller =  watchlist(with: Portfolio.list, title: L.Portfolio.my)
        controller.tabBarItem = TabBarItem(title: L.Tab.portfolio,
                                           image: Bundle.current.image(#imageLiteral(resourceName: "portfolio")),
                                           selectedImage: Bundle.current.image(#imageLiteral(resourceName: "a_portfolio")))
        return controller
    }
    
    var watchList: WatchlistViewController {
        return watchlist(with: SavedEquities.list, title: L.Portfolio.watch)
    }
    
    var cryptocurrencies: WatchlistViewController {
        let type = SymbolsType.cryptocurrensies
        let list = self.list(for: type)
        return watchlist(with: list, title: type.title)
    }
    
    var stocks: WatchlistViewController {
        let type = SymbolsType.stocks
        let list = self.list(for: type)
        return watchlist(with: list, title: type.title)
    }
    
    var forex: WatchlistViewController {
        let type = SymbolsType.forex
        let list = self.list(for: type)
        return watchlist(with: list, title: type.title)
    }
    
    var testMode: TestModeViewController {
        return TestModeViewController(with: coordinator)
    }
    
    fileprivate func watchlist(with list: Watchlist<MarketItem>, title: String) -> WatchlistViewController {
        let service = SymbolsService.shared
        let viewModel = WatchlistViewModel(with: service, list: list)
        let controller = WatchlistViewController(with: viewModel, coordinator: coordinator)
        controller.indicator = title
        return controller
    }
    
    fileprivate func list(for type: SymbolsType) -> Watchlist<MarketItem> {
        switch type {
        case .cryptocurrensies: return Watchlist(items: [
            MarketItem(name: "Bitcoin", code: "BTC", info: "BTC", type: .cryptocurrensies),
            MarketItem(name: "Ripple", code: "XRP", info: "XRP", type: .cryptocurrensies),
            MarketItem(name: "Etherium", code: "ETH", info: "ETH", type: .cryptocurrensies),
            MarketItem(name: "Bitcoin Cash", code: "BCH", info: "BCH", type: .cryptocurrensies),
            MarketItem(name: "Eaton Vance Enhanced Equity", code: "EOS", info: "EOS", type: .cryptocurrensies)
            ])
        case .stocks: return Watchlist(items: [
            MarketItem(name: "Apple Inc.", code: "AAPL", info: "AAPL", type: .stocks),
            MarketItem(name: "Twitter Inc.", code: "TWTR", info: "TWTR", type: .stocks),
            MarketItem(name: "Tesla Inc.", code: "TSLA", info: "TSLA", type: .stocks),
            MarketItem(name: "Facebook Inc.", code: "FB", info: "FB", type: .stocks),
            MarketItem(name: "Amazon.com Inc.", code: "AMZN", info: "AMZN", type: .stocks)
            ])
        case .forex: return Watchlist(items: [
            MarketItem(name: "Euro", code: "EUR", info: "EUR", type: .forex),
            MarketItem(name: "British Pound Sterling", code: "GBP", info: "GBP", type: .forex),
            MarketItem(name: "Japanese Yen", code: "JPY", info: "JPY", type: .forex),
            MarketItem(name: "Australian Dollar", code: "AUD", info: "AUD", type: .forex),
            MarketItem(name: "Swiss Franc", code: "CHF", info: "CHF", type: .forex)
            ])
        }
    }
}
