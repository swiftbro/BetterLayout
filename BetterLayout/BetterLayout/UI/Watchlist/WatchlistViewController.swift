//
//  WatchlistViewController.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit
import PromiseKit
import Charts

protocol WatchlistCoordinator {
    func show(_ item: MarketItem, from presenter: UIViewController)
    func showEmptyDetails(for controller: UIViewController)
    func detailsIsEmpty(for controller: UIViewController) -> Bool
}

class WatchlistViewController: UIViewController, TabPage {
    
    var indicator: String = "WatchList"
    
    // MARK: Init
    
    init(with viewModel: WatchlistViewModel, coordinator: WatchlistCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override public func loadView() {
        let view = isPortfolio ? PortfolioView() : WatchlistView()
        tableView = view.tableView
        self.view = view
        updatePortfolioHeader()
    }
    
    private func updatePortfolioHeader() {
        guard let view = self.view as? PortfolioView else { return }
        view.headerView.isHidden = Portfolio.list.items.count == 0        
        
        guard let info = Portfolio.currentInfo else { return }
        view.cashLabel.attributed.text = "Cash: $\(Portfolio.availableCash.maxFractions(2))"
        view.portfolioLabel.attributed.text = "Portfolio: $\(info.amount.maxFractions(2))"
        
        let start = Portfolio.startCash
        let end = info.amount
        let change = end >= start ? (end - start) : (start - end)
        let percent = change / start * 100
        let state: MarketState = end >= start ? .up : .down
        view.netProgress.progressLabel.attributed.text = "$\(change.maxFractions(2)) (\(percent.maxFractions(2))%)"
        view.netProgress.indicatorLabel.attributed.text = state.string
        view.netProgress.progressLabel.attributed.color = state.color
        view.netProgress.indicatorView.backgroundColor = state.color
        view.period = self.period
        view.notifyChange = { self.period = $0 }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if !isPortfolio && UIDevice.isPad {
            selected = 0
        }
        setupTableView()
        viewModel.list.addObserver(self) { [unowned self] _ in self.loadData() }
        Portfolio.list.addObserver(self) { [unowned self] _ in self.loadData() }
        loadData()
    }
    
    func loadData() {
        items = viewModel.list.items.map(listItem)
        tableView.reloadData()
        weak var `self` = self
        updateTime = .now()
        let symbols = viewModel.getSymbols { self?.add($0) }
        іf (symbols) { self?.update } . else { self?.showError } . finally { self?.configurator.endRefreshing() }
    }
    
    private var updateTime: DispatchTime = .now()
    
    private func add(_ symbol: SymbolItem) {
        if configurator.isRefreshing {
            configurator.endRefreshing()
            updateTime = DispatchTime.now() + DispatchTimeInterval.milliseconds(400)
        }
        updateTime = updateTime + DispatchTimeInterval.milliseconds(100)
        DispatchQueue.main.asyncAfter(deadline: updateTime) { self.update(for: symbol) }
    }
    
    private func update(for symbol: SymbolItem) {
        guard let index = items.firstIndex(where: { $0.code == symbol.code && $0.type == symbol.type }) else { return }
        tableView.performBatchUpdates({
            self.items[index] = items[index].with(symbol)
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .left)
        }) { _ in
            guard UIDevice.isPad,
                let selected = self.selected,
                let item = self.items[safe: selected],
                item.symbol != nil,
                self.coordinator.detailsIsEmpty(for: self) || self.tableView.selectedCell == nil
                else { return }
            self.tableView.selectRow(at: selected.row, animated: true, scrollPosition: .none)
            DispatchQueue.main.async {
                if let cell = self.tableView.selectedCell as? SymbolCell { self.select(cell, at: selected) }
            }
        }
    }
    
    private func update(with items: [SymbolItem]) {
        if let view = view as? PortfolioView {
            updatePortfolioHeader()
            let provider = PortfolioValuesProvider(with: items)
            if let last = provider.items.last?.historyData.last {
                provider.calculateFrom = last.date.dateAtStartOf(.day)
            }
            view.updateToday(with: provider)
        }
    }
    
    // MARK: Private
    private let viewModel: WatchlistViewModel
    private let coordinator: WatchlistCoordinator
    private var tableView: UITableView!
    private var configurator: SimpleTableConfigurator!
    private lazy var items: [ListItem] = viewModel.list.items.map(listItem)
    private var isPortfolio: Bool { return viewModel.list === Portfolio.list }
    private var period: ChangePeriod = .net { didSet { tableView.reloadData() }}
    private var selected: Int?
    
    private func listItem(for marketItem: MarketItem) -> ListItem {
        return ListItem(name: marketItem.name, code: marketItem.code, type: marketItem.type, symbol: nil)
    }
    
    private func setupTableView() {
        unowned let `self` = self
        let deselect = UIDevice.isPad && isPortfolio ? self.deselect : nil
        configurator = SimpleTableConfigurator(with: tableView,
                                               rowsNumber: self.items.count,
                                               cell: SymbolCell.self,
                                               configure: self.configure,
                                               selection: self.select,
                                               deselection: deselect,
                                               refresh: self.loadData)
        configurator.rowHeight = 70
        configurator.beginRefreshing()
    }
    
    private func configure(_ cell: SymbolCell, at index: Int) {
        guard let item = items[safe: index] else { return }
        let amount = Portfolio.amount(ofItemWith: item.code, type: item.type)
        if amount > 0 { cell.showInfo(with: "\(amount.maxFractions(2)) owned") }
        else { cell.hideInfo() }
        
        cell.nameLabel.attributed.text = item.code
        
        if let symbol = item.symbol {
            cell.chartView.data = chartData(with: symbol.historyData)
            cell.state = symbol.state
            cell.priceLabel.attributed.text = "$\(symbol.price.maxFractions(2))"
            cell.priceView.isHidden = false
        } else {
            cell.priceView.isHidden = true
        }
        
        if isPortfolio {
            cell.priceView.backgroundColor = view.backgroundColor
            cell.showChange = true
            if let symbol = item.symbol { update(cell, for: symbol) }
        }
        cell.priceLabel.layout(isPortfolio ? .trailing : 8.trailing~999)
    }
    
    private func update(_ cell: SymbolCell, for item: SymbolItem) {
        guard let last = item.historyData.last else { return }
        var item = item
        let amount = Portfolio.amount(ofItemWith: item.code, type: item.type)
        let price = item.price * amount
        cell.priceLabel.attributed.text = "$\(price.maxFractions(2))"
        cell.priceLabel.set(color: item.state.color, align: .right)
        if period == .today {
            item.calculateFrom = last.date.dateAtStartOf(.day)
            let change = (item.changeValue * amount).maxFractions(2)
            let percent = item.changePercent.maxFractions(2)
            cell.changeLabel.attributed.text = item.state.sign + " $\(change) (\(percent)%)"
            cell.changeLabel.set(color: item.state.color, align: .right)
        } else if let start = Portfolio.operationsList.items.first(where: { $0.item.code == item.code })?.price {
            let end = item.price
            let change = (end >= start ? (end - start) : (start - end)) * amount
            let percent = change / start * 100
            let state: MarketState = end >= start ? .up : .down
            cell.changeLabel.attributed.text = state.sign + " $\(change.maxFractions(2)) (\(percent.maxFractions(2))%)"
            cell.changeLabel.set(color: state.color, align: .right)
        }
    }
    
    private func select(_ cell: SymbolCell, at index: Int) {
        selected = index
        let item = items[index]
        if let marketItem = viewModel.list.items.first(where: { $0.code == item.code }) {
            coordinator.show(marketItem, from: self)
        }
    }
    
    private func deselect(_ cell: SymbolCell, at index: Int) {
        guard isPortfolio else { return }
        coordinator.showEmptyDetails(for: self)
    }
    
    private func chartData(with data: [HistoryDataItem]) -> LineChartData {
        var values: [ChartDataEntry] = []
        for (index, item) in data.enumerated() {
            values.append(ChartDataEntry(x: Double(index), y: Double(item.price), data: item.date as NSDate))
        }
        
        let set = LineChartDataSet(entries: values, label: "History")
        set.defaultSetup()
        
        let data = LineChartData(dataSet: set)
        return data
    }

}

struct ListItem {
    let name: String
    let code: String
    let type: SymbolsType
    let symbol: SymbolItem?
    
    func with(_ symbol: SymbolItem) -> ListItem {
        return ListItem(name: name, code: code, type: type, symbol: symbol)
    }
}
