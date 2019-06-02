//
//  TodayChartView.swift
//  Trading
//
//  Created by Vlad Che on 3/9/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit
import Charts
import SwiftDate

enum HistoryPeriod: Int, CaseIterable {
    case day, week, month, quarter, year, all
}

class TodayChartView: View {
    var notifyChange: (HistoryPeriod) -> Void = { _ in }
    var period: HistoryPeriod = .day
    
    //MARK: - Subviews -
    let periodButtons = UICollectionView(frame: .zero, collectionViewLayout: .hotizontal)
    let floatingLabel = UILabel(font: .semibold-12, color: .white, space: 1.25)
    var floatingLabelLeading: NSLayoutConstraint!
    let chartView = LineChartView.default
    
    func arrangeSubviews() {
        addSubviews(periodButtons, floatingLabel, chartView)
        
        periodButtons.layout(24.height, .top, 15.leading, 15.trailing)
        chartView.layout(35.below[periodButtons], .bottom, .leading, .trailing)
        floatingLabel.layout(just.above[chartView], ≥10.leading.trailing)
        floatingLabelLeading = floatingLabel.layout(pin.leading~666).first
    }
    
    func setup() {
        setupChart()
        setupPeriodButtons()
        floatingLabel.alpha = 0
        floatingLabel.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if periodButtons.indexPathsForSelectedItems?.isEmpty ?? true {
            periodButtons.selectItem(at: IndexPath(item: period.rawValue, section: 0), animated: false, scrollPosition: .left)
        }
    }
    
    // MARK: - Private -    
    private var periods: [String] { return HistoryPeriod.allCases.map(\.label) }
    private var configurator: SimpleCollectionConfigurator!
    
    private func setupChart() {
        chartView.leftAxis.drawGridLinesEnabled = true
        chartView.leftAxis.gridColor = #colorLiteral(red:0.61, green:0.67, blue:0.75, alpha:1)
        chartView.dragEnabled = true
        chartView.highlightPerDragEnabled = true
    }
    
    private func setupPeriodButtons() {
        periodButtons.backgroundColor = .clear
        unowned let `self` = self
        let configurator = SimpleCollectionConfigurator(with: periodButtons,
                                                        itemsCount: self.periods.count,
                                                        cell: PeriodCell.self,
                                                        configure: self.configure,
                                                        selection: self.select,
                                                        deselection: self.deselect)
        self.configurator = configurator
    }
    
    private func configure(_ cell: PeriodCell, at index: Int) {
        guard let period = periods[safe: index] else { return }
        if index == self.period.rawValue { select(cell, at: index) }
        cell.label.attributed.text = period
    }
    
    private func select(_ cell: PeriodCell, at index: Int) {
        period = HistoryPeriod(rawValue: index)!
        cell.view.backgroundColor = #colorLiteral(red:0.02, green:0.62, blue:0.94, alpha:1)
        cell.label.attributed.color = .white
        notifyChange(period)
    }
    
    private func deselect(_ cell: PeriodCell, at index: Int) {
        cell.view.backgroundColor = .clear
        cell.label.attributed.color = #colorLiteral(red:0.61, green:0.67, blue:0.75, alpha:1)
    }
}

private extension HistoryPeriod {    
    var label: String {
        switch self {
        case .day: return L.Period.day
        case .week: return L.Period.week
        case .month: return L.Period.month
        case .quarter: return L.Period.quarter
        case .year: return L.Period.year
        case .all: return L.Period.all
        }
    }
}
