//
//  TodayView+Charts.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit
import Charts
import SwiftDate

extension TodayView {
    
    /// Internal method
    func updateChart() {
        if let provider = provider {
            chartView.alpha = 1
            chartView.isUserInteractionEnabled = true
            chartView.noDataText = "Loading..."
            chartView.data = chartData(for: provider)
            chartView.animate()
        } else {
            chartView.alpha = 0.5
            chartView.isUserInteractionEnabled = false
            chartView.noDataText = ""
            showChartPlaceholder()
        }
    }
    
    private func chartData(for provider: ValuesProvider) -> LineChartData {
        var startTradingDate = Portfolio.cashUpdates.first?.date
        if period != .day { startTradingDate = startTradingDate?.dateAt(.startOfDay) }
        var values: [ChartDataEntry] = []
        var colors: [UIColor] = []
        for (index, dataItem) in provider.historyData.enumerated() {
            var isPartOfTotal = true
            if let startTradingDate = startTradingDate, isPortfolio {
                isPartOfTotal = dataItem.date >= startTradingDate
            }
            let first = provider.historyData.first
            let chartDataItem = ChartDataItem(with: dataItem, previous: first)
            values.append(ChartDataEntry(x: Double(index), y: Double(dataItem.price), data: chartDataItem))
            colors.append(isPartOfTotal ? #colorLiteral(red:0.01, green:0.69, blue:0.5, alpha:1) : #colorLiteral(red:0.61, green:0.67, blue:0.75, alpha:1))
        }
        let set = LineChartDataSet(entries: values, label: "History")
        set.colors = colors
        set.circleColors = colors
        setup(set)
        let data = LineChartData(dataSet: set)
        return data
    }
    
    private func setup(_ set: LineChartDataSet) {
        set.defaultSetup()
        let gradientColors = [#colorLiteral(red:0.01, green:0.69, blue:0.5, alpha:1).cgColor, #colorLiteral(red: 0.01, green: 0.69, blue: 0.5, alpha: 0.7021083048).cgColor, #colorLiteral(red: 0.01, green: 0.69, blue: 0.5, alpha: 0.5).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2027504281).cgColor] as CFArray
        let colorLocations: [CGFloat] = [1.0, 0.7, 0.4, 0.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        set.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        set.fillAlpha = 0.9
        set.drawFilledEnabled = true
    }
    
    private func showChartPlaceholder() {
        DispatchQueue.map.async { [weak self] in
            let data = stub("intraday")
            if let symbol = try? JSONDecoder().decode(Symbol.self, from: data) {
                let item = SymbolItem(with: symbol, sort: true)
                DispatchQueue.main.async {
                    guard let `self` = self else { return }
                    self.chartView.data = self.chartData(for: item)
                    self.chartView.animate()
                }
            }
        }
    }
    
}

extension TodayView: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        notifyChartInteraction(true)
        if floatingLabel.isHidden {
            labels.todayLabel.fadeOut()
            floatingLabel.fadeIn()
        }
        guard let provider = entry.data as? ChartDataItem else { return }
        
        floatingLabel.attributed.text = provider.current.date.toString(.custom(dateFormat))
        floatingLabel.sizeToFit()
        floatingLabelLeading.constant = highlight.xPx - floatingLabel.frame.width / 2
        
        updateLabels(with: provider)
    }
    
    private var dateFormat: String {
        switch period {
        case .day, .week, .month: return "HH:mm a 'ET', MMM dd"
        default: return "MMM dd, yyyy"
        }
    }
    
    func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        notifyChartInteraction(false)
        chartView.highlightValue(nil)
        labels.todayLabel.fadeIn()
        floatingLabel.fadeOut()
        updateValues(andChart: false)
    }
}
