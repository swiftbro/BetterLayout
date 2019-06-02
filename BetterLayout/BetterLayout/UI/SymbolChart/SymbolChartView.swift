//
//  SymbolChartView.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit
import Charts
import SwiftDate

class SymbolChartView: View {
    
    //MARK: - Subviews
    let chartView = LineChartView.default
    let nameLabel = UILabel(font: .medium, color: .text)
    let priceLabel = UILabel(font: .medium, color: .lime)
    let changeView = ProgressView.with { $0.backgroundColor = .view }
    let floatingLabel = UILabel(font: .semibold-12, color: .white, space: 1.25)
    
    func arrangeSubviews() {
        addSubviews(chartView, nameLabel, priceLabel, changeView, floatingLabel)
        chartView.layout(pin.leading + 32 ~ 999 ^ nameLabel)
    }
    
    func setup() {
        
    }
}
