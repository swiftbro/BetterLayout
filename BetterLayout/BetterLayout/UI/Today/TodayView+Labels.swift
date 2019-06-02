//
//  TodayView+Labels.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

extension TodayView {
    
    /// Internal method
    func setupLabels() {        
        [buyButton, sellButton, retryButton].forEach {
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .semibold-16
            $0.backgroundColor = #colorLiteral(red:0.02, green:0.69, blue:0.5, alpha:1)
            $0.isHidden = true
        }
        sellButton.backgroundColor = #colorLiteral(red:1, green:0.23, blue:0.45, alpha:1)
        sellButton.setTitle("Sell", for: .normal)
        buyButton.setTitle("Buy", for: .normal)
        retryButton.setTitle("Retry", for: .normal)
        retryButton.layer.cornerRadius = 8
        toPortfolioButton.setTitle("", for: .normal)
        toSearchButton.setTitle("", for: .normal)
        toAnalyticsButton.setTitle("", for: .normal)
    }
    
    /// Internal method
    func updateLabels() {
        [labels.amountLabel, labels.nameLabel, labels.symbolLabel].forEach { $0.attributed.text = nil }
        [labels.amountLabel, labels.nameLabel, labels.symbolLabel].forEach { $0.isHidden = info == nil }
        if let info = info {
            labels.nameLabel.attributed.text = info.name
            labels.symbolLabel.attributed.text = info.description
            labels.amountLabel.attributed.text = "$\(info.amount.maxFractions(2))"
        }
    }
    
    /// Internal method
    func updateLabels(with provider: ValuesProvider?, updateAmount: Bool = true) {
        [labels.progressLabel, highValueLabel, lowValueLabel].forEach {
            $0.attributed.text = nil
        }
        [labels.symbolLabel, labels.todayLabel, chart.periodButtons, separatorX, separatorY, lowLabel, highLabel].forEach {
            $0.isHidden = provider == nil
        }
        if let provider = provider {
            if updateAmount {
                labels.amountLabel.attributed.text = "$\(provider.price.maxFractions(2))"                
            } else if let info = info {
                labels.amountLabel.attributed.text = "$\(info.amount.maxFractions(2))"
            }
            labels.indicatorView.backgroundColor = provider.state.color
            labels.indicatorLabel.attributed.text = provider.state.string
            labels.progressLabel.attributed.color = provider.state.color
            labels.progressLabel.attributed.text = "$\(provider.changeValue.maxFractions(2)) "
                + "(\(provider.changePercent.maxFractions(2))%)"
            lowValueLabel.attributed.text = "$\(provider.low.maxFractions(2))"
            highValueLabel.attributed.text = "$\(provider.high.maxFractions(2))"
            labels.indicatorLabel.attributed.font = .semibold-12
            labels.indicatorView.layoutIfNeeded()
            updateTodayLabel()
            self.removeGestureRecognizer(tap)
        } else {
            labels.nameLabel.attributed.text = "$\(Portfolio.availableCash.maxFractions(2)) available"
            labels.indicatorLabel.attributed.text = "Start trading"
            labels.indicatorView.backgroundColor = #colorLiteral(red:1, green:0.23, blue:0.45, alpha:1)
            labels.indicatorLabel.attributed.font = .semibold-20
            labels.indicatorView.layoutIfNeeded()
            self.addGestureRecognizer(tap)
        }
    }
    
    func updateTodayLabel() {
        labels.todayLabel.attributed.text = period.string
    }
    
}

extension MarketState {
    
    var sign: String { return self == .up ? "+" : "-" }
    
    var color: UIColor {
        switch self {
        case .up: return #colorLiteral(red:0.02, green:0.69, blue:0.5, alpha:1)
        case .down: return #colorLiteral(red:1, green:0.23, blue:0.45, alpha:1)
        }
    }
    
    var string: String {
        switch self {
        case .up: return L.Label.up
        case .down: return L.Label.down
        }
    }
}

extension HistoryPeriod {
    var string: String {
        switch self {
        case .day: return L.Label.day
        case .week: return L.Label.week
        case .month: return L.Label.month
        case .quarter: return L.Label.quarter
        case .year: return L.Label.year
        case .all: return L.Label.all
        }
    }
}
