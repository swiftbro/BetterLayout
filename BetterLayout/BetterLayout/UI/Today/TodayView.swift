//
//  TodayView.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit
import Charts
import SwiftDate

class TodayView: View {
    var notifyChartInteraction: (Bool) -> Void = { _ in }
    var notifyChange: (HistoryPeriod) -> Void = { _ in }
    var period: HistoryPeriod {
        get { return chart.period }
        set { chart.period = newValue }
    }
    var provider: ValuesProvider? {
        didSet { updateValues() }
    }
    
    @objc func updateValues(andChart: Bool = true) {
        emptyView.fadeOut()
        updateLabels(with: provider, updateAmount: false)
        if andChart { updateChart() }
    }
    
    func update(_ info: TodayInfo?) {
        self.info = info
        self.isPortfolio = info?.isPortfolio ?? true
        updateLabels()
    }
    
    //MARK: - Subviews -
    private let scrollView = UIScrollView()
    let refresher = UIRefreshControl()
    let labels = TodayValueLabels()
    let chart = TodayChartView()
    
    let toPortfolioButton = UIButton(type: .custom)
    let toAnalyticsButton = UIButton(type: .custom)
    let toSearchButton = UIButton(type: .custom)
    
    let lowLabel = UILabel(text: L.Label.low, font: .medium, color: #colorLiteral(red:0.61, green:0.67, blue:0.75, alpha:1))
    let highLabel = UILabel(text: L.Label.high, font: .medium, color: #colorLiteral(red:0.61, green:0.67, blue:0.75, alpha:1))
    let lowValueLabel = UILabel(font: .medium, color: .white)
    let highValueLabel = UILabel(font: .medium, color: .white)
    
    let sellButton = UIButton(type: .system)
    let buyButton = UIButton(type: .system)
    var buttonsHeight: [NSLayoutConstraint] = []
    
    let separatorY = UIView { $0.backgroundColor = #colorLiteral(red:0.61, green:0.67, blue:0.75, alpha:1) }
    let separatorX = UIView { $0.backgroundColor = #colorLiteral(red:0.61, green:0.67, blue:0.75, alpha:1) }
    let emptyView = UIView { $0.backgroundColor = #colorLiteral(red:0.03, green:0.05, blue:0.2, alpha:1) }
    let retryButton = UIButton(type: .system)
    
    private(set) lazy var floatingLabel = chart.floatingLabel
    private(set) lazy var floatingLabelLeading = chart.floatingLabelLeading!
    private(set) lazy var chartView = chart.chartView
    
    lazy var tap = UITapGestureRecognizer(target: self, action: #selector(updateValues))
    
    func arrangeSubviews() {
        guard subviews.isEmpty else { return }
        let activity = UIActivityIndicatorView(style: .whiteLarge)
        activity.startAnimating()
        addSubviews(scrollView.with(labels),
                    toSearchButton, toAnalyticsButton, toPortfolioButton,
                    chart,
                    separatorY,
                    lowLabel, lowValueLabel, separatorX, highLabel, highValueLabel,
                    sellButton, buyButton,
                    emptyView.with(activity), retryButton)
        scrollView.layout(labels.height + 97, .top, .leading, .trailing, to: .safearea)
        labels.layout(24.top, 73.bottom).and(.leading, .trailing, to: .safearea)
        
        toPortfolioButton.layout(labels.nameLabel.edges)
        toSearchButton.layout(labels.indicatorView.edges.height)
        toAnalyticsButton.layout(labels.amountLabel.edges)
        
        chart.layout(just.below[scrollView], just.above[separatorY], .leading, .trailing, to: .safearea)
        
        separatorY.layout(56.above[sellButton], 1.height, .leading, .trailing)
        separatorX.layout(8.below[separatorY], 8.above[sellButton], 1.width, .centerX)
        
        22.bottom.constraint(for: lowLabel, lowValueLabel, highLabel, highValueLabel, to: sellButton)
        lowLabel.layout(15.leading, to: .safearea)
        lowValueLabel.layout(16.after[lowLabel], 15.before[separatorX])
        highLabel.layout(15.after[separatorX], 16.before[highValueLabel])
        highValueLabel.layout(15.trailing, to: .safearea)
        buttonsHeight = sellButton.layout(zero.height)
        sellButton.layout(just.before[buyButton], .leading, .bottom, to: .safearea)
        buyButton.layout(sellButton.height.width~999, .trailing, .bottom, to: .safearea)
        
        emptyView.layout(just.below[labels.amountLabel], .leading, .trailing, .bottom)
        activity.layout(.center)
        retryButton.layout(100.width, 50.height, activity.center)
    }
    
    func setup() {
        guard gestureRecognizers.isNilOrEmpty else { return }
        setupLabels()
        chartView.delegate = self
        tap.cancelsTouchesInView = false
        chart.notifyChange = { [unowned self] period in
            self.updateTodayLabel()
            self.notifyChange(period)
        }
        scrollView.refreshControl = refresher
        scrollView.delegate = self
        refresher.tintColor = #colorLiteral(red:0.02, green:0.69, blue:0.5, alpha:1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = scrollView.frame.height + self.refresher.frame.height
        scrollView.contentSize = CGSize(width: scrollView.frame.width,
                                              height: height)
    }
    
    func endRefreshing() {
        refresher.endRefreshing()
    }
    
    func beginRefreshing() {
        scrollView.contentOffset = CGPoint(x: 0, y: -self.refresher.frame.height)
        refresher.beginRefreshing()
    }
    
    // MARK: - Private -
    private(set) var info: TodayInfo?
    private(set) var isPortfolio: Bool = false
    
    @objc private func refresh(_ refresher: UIPanGestureRecognizer) {
        notifyChange(period)
    }
}

extension TodayView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            scrollView.setContentOffset(.zero, animated: false)
        }
    }
}
