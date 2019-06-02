//
//  AnalyticSymbolCell.swift
//  Trading
//
//  Created by Vlad Che on 3/10/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit
import Reusable
import Charts

class AnalyticSymbolCell: Cell, Reusable {
    public var color: UIColor = .lime
    
    // MARK: - Subviews

    public let chartView = LineChartView.default
    public let nameLabel = UILabel(font: .semibold-20, color: .text, space: 1.2)
    public let priceView = UIView()
    public let priceLabel = UILabel(font: .medium, color: .view, align: .center)
    public let floatingLabel = UILabel(font: .semibold-12, color: .white, space: 1.25)
    
    var state: MarketState = .up {
        didSet { priceView.backgroundColor = state.color }
    }
    
    func arrangeSubviews() {
        contentView.addSubviews(chartView, nameLabel, priceView.with(priceLabel), floatingLabel)
        
        chartView.layout(.leading, .trailing, .top, to: .safearea)
        nameLabel.layout(10.trailing.to(priceView), 10.below.the(chartView), 10.bottom, 15.leading, to: .safearea)
        priceView.layout(28.height, ≥69.width, pin.centerY.to(nameLabel))
        priceLabel.layout(≥8.trailing.leading, 5.bottom.top, .centerX)
        priceView.setContentHuggingPriority(.required, for: .horizontal)
        floatingLabel.layout(pin.centerY.to(nameLabel), 15.trailing)
    }
    
    func setup() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .view
        setupLabels()
        state = .down
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.dragEnabled = true
        chartView.highlightPerDragEnabled = true
    }
    
    func updateLabels(with provider: ValuesProvider, amount: Float) {
        let price = provider.price.maxFractions(2)
        let progress = provider.changeValue.maxFractions(2)
        let percent = provider.changePercent.maxFractions(2)
        priceLabel.attributed.text = "\(amount) x $\(price) ($\(progress), \(percent)%)"
        state = provider.state
    }
    
    //MARK: - Private
    
    private func setupLabels() {
        priceView.layer.cornerRadius = 3
        floatingLabel.alpha = 0
        floatingLabel.isHidden = true
    }
}
