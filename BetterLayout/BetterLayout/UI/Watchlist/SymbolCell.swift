//
//  SymbolCell.swift
//  Trading
//
//  Created by Vlad Che on 1/23/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit
import Reusable
import Charts

class SymbolCell: Cell, Reusable {
    
    var showChange: Bool = false {
        didSet {
            changeLabel.isHidden = !showChange
            changeLabelConstraints.isActive = showChange
        }
    }
    
    var state: MarketState = .up {
        didSet {
            priceView.backgroundColor = state.color
            chartView.dataSet?.setColor(state.color)
            chartView.dataSet?.setCircleColor(state.color)
        }
    }
    
    func showInfo(with text: String) {
        infoLabel.attributed.text = text
        infoLabel.isHidden = false
        labelsCenter.first?.isActive = true
    }
    
    func hideInfo() {
        infoLabel.isHidden = true
        labelsCenter.first?.isActive = false
    }
    
    //MARK: - Subviews
    
    public let chartView = LineChartView.default
    public let nameLabel = UILabel(font: .semibold-20, color: .text, space: 1.2)
    public let infoLabel = UILabel(font: .regular, color: #colorLiteral(red: 0.61, green: 0.67, blue: 0.75, alpha: 1))
    public let priceLabel = UILabel(font: .medium, color: .view, align: .center)
    public let changeLabel = UILabel(font: .medium-12, color: #colorLiteral(red: 0.04860365847, green: 0.08588655001, blue: 0.3404226036, alpha: 1), align: .center).hidden()
    public let priceView = UIView()
    private let labels = UIView()
    private var labelsCenter: [NSLayoutConstraint] = []
    private var changeLabelConstraints: [NSLayoutConstraint] = []
    
    func arrangeSubviews() {
        contentView.addSubviews(chartView, labels.with(nameLabel, infoLabel), priceView.with(priceLabel, changeLabel))
        
        labels.layout(16.leading, 10.before[chartView])
        labelsCenter = labels.layout(contentView.centerY, active: false)
        nameLabel.layout(.top, .leading, .trailing, contentView.centerY~666)
        infoLabel.layout(2.below.the(nameLabel), .bottom, .leading, .trailing)
        chartView.layout(108.width, 45.height, .centerY, -10.centerX)
        priceView.layout(≥20.after[chartView], ≥69.width, .centerY, 16.trailing)
        priceView.setContentHuggingPriority(.required, for: .horizontal)
        priceLabel.layout(8.leading~999, 5.top, .centerX, 5.bottom~666)
        changeLabelConstraints =
            changeLabel.layout(5.bottom[.superview], .leadingEdge, .trailingEdge, 2.below, to: priceLabel, active: false)
    }
    
    func setup() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .view
        setupLabels()
        state = .down
        chartView.isUserInteractionEnabled = false
        if UIDevice.isPad { selectionStyle = .blue } else { selectionStyle = .none }
    }
    
    //MARK: - Private
    
    private func setupLabels() {
        labels.backgroundColor = backgroundColor
        infoLabel.isHidden = true
        priceView.layer.cornerRadius = 3
    }
}
