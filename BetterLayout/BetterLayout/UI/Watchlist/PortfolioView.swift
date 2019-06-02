//
//  PortfolioView.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

class PortfolioView: WatchlistView {
    var period: ChangePeriod = .net { didSet { notifyChange?(period) }}
    var notifyChange: ((_ period: ChangePeriod) -> Void)?
    
    //MARK: - Subviews
    private let text = AttributedParameters(font: .medium-16, color: #colorLiteral(red:0.61, green:0.67, blue:0.75, alpha:1), space: 1.2)
    let headerView = UIView { $0.backgroundColor = #colorLiteral(red:0.03, green:0.05, blue:0.2, alpha:1) }
    private(set) lazy var cashLabel = UILabel(attributes: text)
    private(set) lazy var portfolioLabel = UILabel(attributes: text)
    private(set) lazy var periodButton = UIButton(type: .system)
    let netProgress = ProgressView()
    let todayProgress = ProgressView().hidden()
    
    override func arrangeSubviews() {
        super.arrangeSubviews()
        
        headerView.addSubviews(cashLabel, portfolioLabel, periodButton, netProgress, todayProgress)
        
        cashLabel.layout(16.leading, 20.top, 5.before[headerView.centerX])
        portfolioLabel.layout(16.trailing, 20.top, just.after[headerView.centerX])
        periodButton.layout(16.leading, 10.before[netProgress], 15.below[cashLabel], 20.bottom)
        netProgress.layout(just.after[headerView.centerX], periodButton.centerY, ≥16.trailing)
        todayProgress.layout(netProgress.edges)
        
        tableView.tableHeaderView = headerView
        headerView.layout(tableView.width)
    }
    
    override func setup() {
        super.setup()
        periodButton.setTitle("Net change:", for: .normal)
        periodButton.setTitleColor(#colorLiteral(red:0.02, green:0.62, blue:0.94, alpha:1), for: .normal)
        periodButton.titleLabel?.font = .semibold-16
        periodButton.contentHorizontalAlignment = .left
        [netProgress, todayProgress].forEach { $0.indicatorLabel.text = "..." }
        periodButton.addAction { [unowned self] in
            if self.period == .net {
                self.netProgress.fadeOut()
                self.todayProgress.fadeIn()
                self.periodButton.setTitle("Today change:", for: .normal)
                self.period = .today
            } else {
                self.netProgress.fadeIn()
                self.todayProgress.fadeOut()
                self.periodButton.setTitle("Net change:", for: .normal)
                self.period = .net
            }
        }
    }
    
    func updateToday(with provider: ValuesProvider) {
        todayProgress.progressLabel.attributed.text = "$\(provider.changeValue.maxFractions(2)) (\(provider.changePercent.maxFractions(2))%)"
        todayProgress.indicatorLabel.attributed.text = provider.state.string
        todayProgress.progressLabel.attributed.color = provider.state.color
        todayProgress.indicatorView.backgroundColor = provider.state.color
    }
    
}

enum ChangePeriod {
    case net, today
}
