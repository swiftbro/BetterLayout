//
//  AnalyticsView.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit
import Charts
import SwiftDate

extension UIView {
    var width: CGFloat { return frame.width }
}

class AnalyticsView: View {
    var notifyChange: (HistoryPeriod) -> Void = { _ in }
    var period: HistoryPeriod {
        get { return chart.period }
        set { chart.period = newValue }
    }
    
    var provider: PortfolioValuesProvider! {
        didSet { updateValues() }
    }
    
    func updateValues() {
        updateLabels(with: provider)
        updateChart()
        items = provider.items
        tableView.reloadData()
        configurator.endRefreshing()
    }
    
    //MARK: - Subviews -
    let labels = TodayValueLabels()
    private(set) lazy var symbolLabel = labels.symbolLabel
    private(set) lazy var nameLabel = labels.nameLabel
    let chart = TodayChartView()
    private(set) lazy var floatingLabel = chart.floatingLabel
    private(set) lazy var floatingLabelLeading = chart.floatingLabelLeading!
    private(set) lazy var chartView = chart.chartView
    let retryButton = UIButton(type: .system)
    let tableView = UITableView.default
    let refresher = UIRefreshControl()
    let infoLabel = UILabel()
    
    func arrangeSubviews() {
        addSubview(tableView)
        
        let headerView = UIView { $0.backgroundColor = #colorLiteral(red:0.03, green:0.05, blue:0.2, alpha:1) }
        headerView.addSubviews(labels, infoLabel, chart, retryButton)
        
        labels.layout(24.top, .leading, .trailing)
        infoLabel.layout(symbolLabel.topEdge, nameLabel.bottomEdge, 15.leading.trailing[.safearea])
        chart.layout(30.below[labels], .leading, .trailing, .bottom)
        retryButton.layout(100.width, 50.height, chartView.center)
        
        tableView.tableHeaderView = headerView
        tableView.layout(.edges, to: .safearea)
        headerView.layout(400.height, tableView.width)
    }
    
    func setup() {
        setupTableView()
        chartView.delegate = self
        chartView.leftAxis.drawGridLinesEnabled = false
        chart.notifyChange = { [unowned self] period in
            self.updateTodayLabel()
            self.notifyChange(period)
        }
        infoLabel.set(font: .medium-16, color: #colorLiteral(red:0.61, green:0.67, blue:0.75, alpha:1), lines: 0, space: 1.2)
        infoLabel.backgroundColor = backgroundColor
        infoLabel.alpha = 0
    }
    
    // MARK: - Private
    private var configurator: SimpleTableConfigurator!
    var items: [SymbolItem] = []
    
    private func setupTableView() {
        unowned let `self` = self
        configurator = SimpleTableConfigurator(with: tableView,
                                               rowsNumber: self.items.count,
                                               cell: AnalyticSymbolCell.self,
                                               configure: self.configure,
                                               selection: self.select,
                                               refresh: { self.notifyChange(self.period) })
        configurator.rowHeight = 150
        configurator.beginRefreshing()
    }
    
    private func configure(_ cell: AnalyticSymbolCell, at index: Int) {
        guard let item = items[safe: index] else { return }
        cell.nameLabel.attributed.text = item.code
        cell.color = #colorLiteral(red: 0.989123404, green: 0.9498998523, blue: 0, alpha: 1)
        cell.chartView.data = chartData(for: item, color: cell.color, fill: false)
        cell.chartView.animate()
        cell.chartView.delegate = self
        let amount = Portfolio.amount(of: MarketItem.with(item.code))
        cell.updateLabels(with: item, amount: amount)
    }
    
    private func select(_ cell: AnalyticSymbolCell, at index: Int) {
        
    }

}
