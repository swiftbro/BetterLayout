//
//  AnalyticsView+Labels.swift
//  Trading
//
//  Created by Vlad Che on 3/10/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit

extension AnalyticsView {
    /// Internal method
    func updateLabels(with provider: ValuesProvider) {
        labels.symbolLabel.attributed.text = "Available: $\(Portfolio.availableCash)"
        labels.nameLabel.attributed.text = "Total amount:"
        labels.amountLabel.attributed.text = "$\(provider.price.maxFractions(2))"
        labels.indicatorView.backgroundColor = provider.state.color
        labels.indicatorLabel.attributed.text = provider.state.string
        labels.indicatorView.layoutIfNeeded()
        labels.progressLabel.attributed.color = provider.state.color
        labels.progressLabel.attributed.text = "$\(provider.changeValue.maxFractions(2)) "
            + "(\(provider.changePercent.maxFractions(2))%)"
        updateTodayLabel()
    }
    
    func updateTodayLabel() {
        labels.todayLabel.attributed.text = period.string
    }
}
