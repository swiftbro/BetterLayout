//
//  AnalyticsViewController.swift
//  Trading
//
//  Created by Vlad Che on 3/9/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit
import Charts

class AnalyticsViewController: UIViewController { 
    
    // MARK: Init
    
    init(with viewModel: TodayViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func loadView() {
        let view = AnalyticsView()
        self.view = view
        chartView = view.chartView
        retryButton = view.retryButton
        retryButton.addAction { [unowned view] in
            self.update(for: view.period)
        }
        view.notifyChange = { period in
            self.update(for: period)            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var `self` = self
        viewModel.list.addObserver(self!, action: { items in
            guard let self = self else { return }
            self.update(for: self.analyticsView.period)
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    func update(for period: HistoryPeriod) {
        weak var `self` = self
        retryButton.isHidden = true
        chartView.clear()
        let items = viewModel.items(for: period)
        іf (items) { self?.update } . else { self?.showError }
    }
    
    func update(for items: [SymbolItem]) {
        analyticsView.provider = PortfolioValuesProvider(with: items)
    }
    
    override func showError(_ error: Error) {
        super.showError(error)
        retryButton.isHidden = false
    }
    
    // MARK: - Private
    private var analyticsView: AnalyticsView { return self.view as! AnalyticsView } 
    private let viewModel: TodayViewModel
    private var chartView: LineChartView!
    private var retryButton: UIButton!
}
