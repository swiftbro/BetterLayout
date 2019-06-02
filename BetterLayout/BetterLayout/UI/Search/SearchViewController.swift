//
//  SearchViewController.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit
import PromiseKit

protocol SearchCoordinator {
    func show(_ item: MarketItem, from presenter: UIViewController)
    func showEmptyDetails(for controller: UIViewController)
    func isWatching(_ item: MarketItem) -> Bool
    func watch(_ item: MarketItem)
}

class SearchViewController: UIViewController {
    
    // MARK: Init
    
    init(with viewModel: SearchViewModel, coordinator: SearchCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override public func loadView() {
        let view = SearchView()
        self.view = view
        tableView = view.tableView
        searchField = view.searchField
        unowned let `self` = self
        view.searchCleanButton.addAction(self.clean)
        searchField.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.list.addObserver(self) { [unowned self] _ in self.tableView.reloadData() }
        navigationItem.title = L.Tab.search
        setupTableView()
        suggest()
    }
    
    // MARK: Private
    private let viewModel: SearchViewModel
    private let coordinator: SearchCoordinator
    private var tableView: UITableView!
    private var searchField: UITextField!
    private var configurator: SectionedTableConfigurator!
    private var selected: MarketItem?
    private var sections: [SectionedTableConfigurator.SectionInfo] {
        return Section.allCases.map { ($0.title, $0.items(for: self).count) }.filter { $0.rowsNumber > 0 }
    }
    
    fileprivate var cryptos: [MarketItem] = []
    fileprivate var stocks: [MarketItem] = []
    fileprivate var forex: [MarketItem] = []
    
    private func suggest() {
        viewModel.suggestions.items.forEach {
            switch $0.type {
            case .cryptocurrensies: cryptos.append($0)
            case .stocks: stocks.append($0)
            case .forex: forex.append($0)
            }
        }
        reloadTable()
    }
    
    private func clean() {
        searchField.text = ""
        cryptos = []
        stocks = []
        forex = []
        tableView.reloadData()
        if !searchField.isFirstResponder { suggest() }
    }
    
    fileprivate func search() {
        search(searchField.text ?? "")
    }
    
    fileprivate func search(_ text: String) {
        self.stocks.removeAll(where: { !($0.name + $0.code).contains(text, options: .caseInsensitive) })
        reloadTable()
        weak var `self` = self
        let cryptos = viewModel.searchCryptos(text)
        let stocks = viewModel.searchStocks(text)
        let forex = viewModel.searchForex(text)
        іf (cryptos) { self?.updateCryptos } . else { self?.showError }
        іf (stocks) { self?.updateStocks } . else { self?.showError }
        іf (forex) { self?.updateForex } . else { self?.showError }
    }
    
    private func updateCryptos(_ items: [MarketItem]) {
        self.cryptos = items
        reloadTable()
    }
    
    private func updateStocks(_ items: [MarketItem]) {
        self.stocks = items
        reloadTable()
    }
    
    private func updateForex(_ items: [MarketItem]) {
        self.forex = items
        reloadTable()
    }
    
    private func reloadTable() {
        tableView.reloadData()
        selectCellIfNeeded()
    }
    
    private func  selectCellIfNeeded() {
        if  UIDevice.isPad,
            let type = selected?.type,
            let selected = selected,
            let section = Section.index(for: type, controller: self, skipEmpty: true) {
            let items = Section.for(type).items(for: self)
            guard let index = items.firstIndex(of: selected) else { return }
            self.tableView.selectRow(at: IndexPath(row: index, section: section), animated: true, scrollPosition: .none)
        }
    }
    
    private func setupTableView() {
        unowned let `self` = self
        let deselect = UIDevice.isPad ? self.deselect : nil
        configurator = SectionedTableConfigurator(with: tableView,
                                               sections: self.sections,
                                               cell: SearchCell.self,
                                               configure: self.configure,
                                               selection: self.select,
                                               deselection: deselect)
        configurator.headerHeight = 70
        configurator.rowHeight = 88
        configurator.sectionHeaderInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    private func configure(_ cell: SearchCell, at section: Int, with index: Int) {
        guard let item = self.item(for: index, at: section) else {return}
        cell.nameLabel.attributed.text = item.name
        cell.infoLabel.attributed.text = item.info
        let image = coordinator.isWatching(item) ? #imageLiteral(resourceName: "checkmark") : #imageLiteral(resourceName: "add")
        cell.addButton.setImage(image, for: .normal)
        cell.addButton.addAction { [unowned self] in
            self.coordinator.watch(item)
        }
    }
    
    private func select(_ cell: SearchCell, at section: Int, row index: Int) {
        guard let item = self.item(for: index, at: section) else {return}
        selected = item
        coordinator.show(item, from: self)
    }
    
    private func deselect(_ cell: SearchCell, at section: Int, row index: Int) {
        coordinator.showEmptyDetails(for: self)
    }
    
    private func item(for index: Int, at section: Int) -> MarketItem? {
        guard let section = Section.with(index: section, for: self, skipEmpty: true) else {return nil}
        return section.items(for: self)[safe: index]
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text ?? "") as NSString
        let result = text.replacingCharacters(in: range, with: string)
        search(result)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty { clean() }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty { suggest() }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SearchViewController {
    enum Section: Int, CaseIterable {
        case cryptos, stocks, forex
        
        var title: String {
            switch self {
            case .cryptos: return "CRYPTOCURRENCIES"
            case .stocks: return "STOCKS"
            case .forex: return "FOREX"
            }
        }
        
        static func `for`(_ type: SymbolsType) -> Section {
            switch type {
            case .cryptocurrensies: return .cryptos
            case .stocks: return .stocks
            case .forex: return .forex
            }
        }
        
        static func with(index: Int, for controller: SearchViewController, skipEmpty: Bool) -> Section? {
            guard skipEmpty else { return Section(rawValue: index) }
            var tryIndex = index
            while let section = Section(rawValue: tryIndex), section.items(for: controller).isEmpty {
                tryIndex += 1
            }
            return Section(rawValue: tryIndex)
        }
        
        static func index(for type: SymbolsType, controller: SearchViewController, skipEmpty: Bool) -> Int? {
            let section = Section.for(type)
            guard skipEmpty else { return section.rawValue }
            return Section.allCases.filter { !$0.items(for: controller).isEmpty }.firstIndex(of: section)
        }
        
        func items(for controller: SearchViewController) -> [MarketItem] {
            switch self {
            case .cryptos: return controller.cryptos
            case .stocks: return controller.stocks
            case .forex: return controller.forex
            }
        }
    }
}
