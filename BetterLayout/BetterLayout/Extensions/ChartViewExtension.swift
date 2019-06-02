//
//  ChartViewExtension.swift
//  Trading
//
//  Created by Vlad Che on 2/25/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit
import Charts

extension LineChartView {
    static var `default`: LineChartView {
        let chartView = LineChartView()
        chartView.backgroundColor = .clear
        chartView.setViewPortOffsets(left: 0, top: 0, right: 0, bottom: 0)
        chartView.chartDescription?.enabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.legend.enabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = true
        chartView.xAxis.enabled = true
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.xAxis.drawLabelsEnabled = false
        
        chartView.dragEnabled = false
        chartView.highlightPerDragEnabled = false
        chartView.highlightPerTapEnabled = false
        
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        
        chartView.noDataFont = .semibold-20
        chartView.noDataTextColor = .white
        chartView.noDataTextAlignment = .center
        chartView.noDataText = "Loading..."
        
        return chartView
    }
    
    var dataSet: LineChartDataSet? {
        return data?.dataSets.first as? LineChartDataSet
    }
    
    func animate() {
        guard let dataSet = dataSet else { return }
        let duration = dataSet.count < 30 ? 0.2 : 1.0
        animate(xAxisDuration: duration)
    }
}

extension LineChartDataSet {
    func defaultSetup() {
        self.lineWidth = 3
        self.drawCirclesEnabled = true
        self.circleRadius = 1.5
        self.drawValuesEnabled = false
        self.drawCircleHoleEnabled = false
        self.drawHorizontalHighlightIndicatorEnabled = false
        self.drawVerticalHighlightIndicatorEnabled = true
        self.highlightColor = #colorLiteral(red:0.02, green:0.62, blue:0.94, alpha:1)
        self.highlightLineWidth = 2
        self.axisDependency = .left
    }
}
