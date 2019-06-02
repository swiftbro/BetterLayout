//
//  AnalyticsView+Chart.swift
//  Trading
//
//  Created by Vlad Che on 3/10/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import Foundation
import Charts
import SwiftDate

extension AnalyticsView {
    
    /// Internal method
    func updateChart() {
        chartView.alpha = 1
        chartView.isUserInteractionEnabled = true
        chartView.noDataText = "Loading..."
        chartView.data = chartData(for: provider)
        chartView.animate()
    }
    
    func chartData(for provider: ValuesProvider, color: UIColor = #colorLiteral(red:0.02, green:0.69, blue:0.5, alpha:1), fill: Bool = true) -> LineChartData {
        var startTradingDate = Portfolio.cashUpdates.first!.date
        if period != .day { startTradingDate = startTradingDate.dateAt(.startOfDay) }
        var values: [ChartDataEntry] = []
        var colors: [UIColor] = []
        let historyData = self.provider.adjusted(provider.historyData)
        for (index, dataItem) in historyData.enumerated() {
            var isPartOfTotal = dataItem.date >= startTradingDate
            if let symbol = provider as? SymbolItem {
                let amount = Portfolio.amount(ofItemWith: symbol.code, type: symbol.type, till: dataItem.date)
                isPartOfTotal = amount > 0
            }
            let first = provider.historyData.first
            let chartDataItem = ChartDataItem(with: dataItem, previous: first)
            values.append(ChartDataEntry(x: Double(index), y: Double(dataItem.price), data: chartDataItem))
            colors.append(isPartOfTotal ? color : #colorLiteral(red:0.61, green:0.67, blue:0.75, alpha:1))
        }
        let set = LineChartDataSet(entries: values, label: "History")
        set.colors = colors
        set.circleColors = colors
        setup(set, color: color, fill: fill)
        let data = LineChartData(dataSet: set)
        return data
    }
    
    private func setup(_ set: LineChartDataSet, color: UIColor, fill: Bool = true) {
        set.defaultSetup()
        if fill {
            let gradientColors = [color.cgColor, color.withAlphaComponent(0.7).cgColor, color.withAlphaComponent(0.5).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2027504281).cgColor] as CFArray
            let colorLocations: [CGFloat] = [1.0, 0.7, 0.4, 0.0]
            let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
            set.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
            set.fillAlpha = 0.9
        }
        set.drawFilledEnabled = fill
    }
    
}

extension AnalyticsView: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry.x, entry.y)
        if floatingLabel.isHidden {
            labels.todayLabel.fadeOut()
            floatingLabel.fadeIn()
            infoLabel.fadeIn()
        }
        guard let chartItem = entry.data as? ChartDataItem else { return }
        
        floatingLabel.attributed.text = chartItem.current.date.toString(.custom(dateFormat))
        floatingLabel.sizeToFit()
        floatingLabelLeading.constant = highlight.xPx - floatingLabel.frame.width / 2
        
        if let index = self.provider.historyData.firstIndex(where: { $0.date >= chartItem.current.date }) {
            infoLabel.attributed.text = self.provider.historyDataInfo[safe: index]
            
            if self.chartView === chartView {
                updateLabels(with: chartItem)
            } else {
                let current = self.provider.historyData[index]
                let previous = self.provider.historyData[safe: index - 1]
                let provider = ChartDataItem(with: current, previous: previous)
                updateLabels(with: provider)
                let selfHighlight = Highlight(x: highlight.x, y: Double(current.price), dataSetIndex: 0)
                self.chartView.highlightValue(selfHighlight)
            }
        }
        
        for cell in tableView.visibleCells {
            guard let cell = cell as? AnalyticSymbolCell, let index = tableView.indexPath(for: cell)?.row else { return }
            let item = items[index]
            let amount = Portfolio.amount(ofItemWith: item.code, type: item.type, till: chartItem.current.date)
            if cell.chartView == chartView {
                cell.updateLabels(with: chartItem, amount: amount)
            } else {
                let historyData = self.provider.adjusted(item.historyData)
                if let index = historyData.firstIndex(where: { $0.date >= chartItem.current.date }) {
                    let current = historyData[index]
                    let previous = historyData[safe: index - 1]
                    let provider = ChartDataItem(with: current, previous: previous)
                    cell.updateLabels(with: provider, amount: amount)
                    let cellHighlight = Highlight(x: highlight.x, y: Double(current.price), dataSetIndex: 0)
                    cell.chartView.highlightValue(cellHighlight)
                }                
            }
        }
    }
    
    private var dateFormat: String {
        switch period {
        case .day, .week, .month: return "HH:mm a 'ET', MMM dd"
        default: return "MMM dd, yyyy"
        }
    }
    
    func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        self.chartView.highlightValue(nil)
        for cell in tableView.visibleCells {
            guard let cell = cell as? AnalyticSymbolCell else { return }
            cell.chartView.highlightValue(nil)
        }
        labels.todayLabel.fadeIn()
        floatingLabel.fadeOut()
        infoLabel.fadeOut()
        updateValues()
    }
}
