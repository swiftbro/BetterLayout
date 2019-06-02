//
//  TodayValueLabels.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

class ProgressView: View {
    // MARK: - Subviews
    let indicatorView = UIView()
    let indicatorLabel = UILabel(font: .semibold-12, color: .white, align: .center, space: 1.25)
    let progressLabel = UILabel(font: .semibold)
    
    func arrangeSubviews() {
        addSubviews(indicatorView.with(indicatorLabel), progressLabel)
        indicatorView.layout(.leading, .top, .bottom)
        indicatorLabel.layout(3.edges)
        indicatorLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        indicatorLabel.setContentHuggingPriority(.required, for: .vertical)
        indicatorLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        indicatorLabel.setContentHuggingPriority(.required, for: .horizontal)
        progressLabel.layout(10.after[indicatorView], indicatorView.centerY, .trailing)
    }
    
    func setup() {
        backgroundColor = #colorLiteral(red:0.03, green:0.05, blue:0.2, alpha:1)
        indicatorView.layer.cornerRadius = 3
    }
}

class TodayValueLabels: View {
    // MARK: - Subviews
    let symbolLabel = UILabel(font: .medium-16, color: #colorLiteral(red:0.61, green:0.67, blue:0.75, alpha:1), space: 1.2)
    let nameLabel = UILabel(font: .semibold-20, color: .white, space: 1.2)
    let amountLabel = UILabel(font: .semibold-20, color: .white, space: 1.2)
    let progressView = ProgressView()
    private(set) lazy var indicatorView = progressView.indicatorView
    private(set) lazy var indicatorLabel = progressView.indicatorLabel
    private(set) lazy var progressLabel = progressView.progressLabel
    private(set) lazy var todayLabel = UILabel(font: .semibold, color: .white)
    
    func arrangeSubviews() {
        addSubviews(symbolLabel, nameLabel, amountLabel, progressView, todayLabel)
        
        15.leading.constraint(for: symbolLabel, nameLabel, amountLabel, progressView)
        ≥15.trailing.constraint(for: symbolLabel, nameLabel, amountLabel, todayLabel)
        symbolLabel.layout(.top)
        nameLabel.layout(17.below[symbolLabel])
        amountLabel.layout(8.below[nameLabel])
        progressView.layout(14.below[amountLabel], .bottom)
        todayLabel.layout(11.leading, .centerY, to: progressLabel)
    }
    
    func setup() {
        backgroundColor = #colorLiteral(red:0.03, green:0.05, blue:0.2, alpha:1)
        subviews.forEach {
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
            $0.setContentHuggingPriority(.required, for: .vertical)
        }
    }
}
