//
//  TodayViewController.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Charts
import PromiseKit

protocol TodayCoordinator {    
    var portfolio: Watchlist<MarketItem> {get}
    var watchlist: Watchlist<MarketItem> {get}
    
    func isWatching(_ item: MarketItem) -> Bool
    func watch(_ item: MarketItem)
    func canSell(_ item: MarketItem) -> Bool
    func sell(_ item: MarketItem)
    func buy(_ item: MarketItem)
    func showPortfolio()
    func showSearch()
    func showAnalytics()
    func stopTransitions()
    func resumeTransitions()
}

class TodayViewController: UIViewController, TabPage {
    
    let indicator: String = "Portfolio"
    private var chartView: LineChartView!
    private var retryButton: UIButton!
    private let watchButton = UIButton(type: .custom)
    
    // MARK: Init
    
    init(with viewModel: TodayViewModel, coordinator: TodayCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override public func loadView() {
        let view = TodayView()
        self.view = view
        chartView = view.chartView
        retryButton = view.retryButton
        unowned let `self` = self
        view.toPortfolioButton.addAction(self.coordinator.showPortfolio)
        view.toSearchButton.addAction(self.coordinator.showSearch)
        view.toAnalyticsButton.addAction(self.coordinator.showAnalytics)
        view.refresher.addAction(for: .valueChanged, self.updateInfo)
        view.period = viewModel.list.items.allSatisfy({ $0.type == .cryptocurrensies }) ? .month : .day
        updateButtons()
        if isPortfolio {
            view.update(Portfolio.currentInfo)
        } else if let item = viewModel.list.items.first {
            view.update(TodayInfo(name: item.name, description: item.code))
        }
        viewModel.list.addObserver(self, action: { [unowned view] items in
            self.update(for: view.period)
            self.updateButtons()
        })
        retryButton.addAction { [unowned view] in
            self.update(for: view.period)
        }
        view.notifyChange = { period in
            self.update(for: period)
        }
        view.notifyChartInteraction = { isInteracting in
            isInteracting ? self.coordinator.stopTransitions()  : self.coordinator.resumeTransitions()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButtons()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    func updateInfo() {
        weak var view = self.view as? TodayView
        weak var `self` = self
        let info = viewModel.info.ensure { view?.endRefreshing() }
        іf (info) { view?.update } . else { self?.showError }
    }
    
    func update(for period: HistoryPeriod) {
        updateInfo()
        weak var `self` = self
        retryButton.isHidden = true
        chartView.clear()
        let items = viewModel.items(for: period)
        іf (items) { self?.update } . else { self?.showError }
    }
    
    func update(for items: [SymbolItem]) {
        guard let view = view as? TodayView else {return}
        view.toSearchButton.isHidden = true
        view.toPortfolioButton.isHidden = true
        
        // For item
        if !isPortfolio, let item = items.first {
            view.provider = item
        }
        // For portfolio
        else if !items.isEmpty {
            view.provider = PortfolioValuesProvider(with: items)
            view.toPortfolioButton.isHidden = false
        }
        // For empty portfolio
        else {
            view.provider = nil
            view.toSearchButton.isHidden = false
        }
    }
    
    override func showError(_ error: Error) {
        super.showError(error)
        retryButton.isHidden = false
    }
    
    // MARK: Private
    private let viewModel: TodayViewModel
    private let coordinator: TodayCoordinator
    
    private var isPortfolio: Bool { return viewModel.isPortfolio }
    
    func updateButtons() {
        guard let view = view as? TodayView else {return}
        let items = viewModel.list.items
        if isPortfolio || items.isEmpty {
            view.buttonsHeight.forEach{ $0.constant = 0 }
            [view.sellButton, view.buyButton].forEach { $0.isHidden = true }
        } else if let item = items.first {
            view.buttonsHeight.forEach{ $0.constant = 56 }
            [view.sellButton, view.buyButton].forEach { $0.isHidden = false }
            
            navigationItem.title = item.name
            
            if (sellButtonZeroWidth.isEmpty) {
                sellButtonZeroWidth = view.sellButton.layout(zero.width, active: false)
            }
            sellButtonZeroWidth.forEach { $0.isActive = !coordinator.canSell(item) }
            
            let image = coordinator.isWatching(item) ? #imageLiteral(resourceName: "checkmark") : #imageLiteral(resourceName: "add")
            watchButton.setImage(image, for: .normal)
            watchButton.sizeToFit()
            
            if !view.sellButton.hasAction {
                unowned let `self` = self
                view.sellButton.addAction { self.coordinator.sell(item) }
                view.buyButton.addAction { self.coordinator.buy(item) }
                navigationItem.rightBarButtonItem = UIBarButtonItem(customView: watchButton)
                watchButton.addAction { self.coordinator.watch(item) }
                coordinator.watchlist.addObserver(self) { _ in self.updateButtons() }
                coordinator.portfolio.addObserver(self) { _ in self.updateButtons() }
            }
        }
    }
    
    lazy var sellButtonZeroWidth: [NSLayoutConstraint] = []
}
