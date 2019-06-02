//
//  BuySellViewController.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit
import PromiseKit

extension UIViewController {
    var baseView: UIView { return view }
}

class ViewController: UIViewController {}

protocol BuySellViewHolder {
    var view: BuySellView { get }
}

extension BuySellViewHolder where Self: BuySellViewController {
    var view: BuySellView { return baseView as! BuySellView }
}

class BuySellViewController: UIViewController, BuySellViewHolder {
    
    // MARK: Init
    
    init(with viewModel: BuySellViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override public func loadView() {
        let view = BuySellView()
        self.view = view
        view.doneButton.backgroundColor = viewModel.operation.color
        view.doneButton.setTitle(viewModel.operation.title, for: .normal)
        title = "Market " + viewModel.operation.title
        unowned let `self` = self
        view.doneButton.addAction(self.done)
        view.amountField.delegate = self
        view.amountLabel.attributed.text = "AMOUNT OF \(viewModel.item.code)"
        view.priceLabel.attributed.text = "\(viewModel.item.code) PRICE"
        view.costLabel.attributed.text = "EST COST"
        view.costValueLabel.attributed.text = "0"
        view.refresher.addAction(for: .valueChanged, self.loadData)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        weak var `self` = self
        buySellView.beginRefreshing()
        іf (viewModel.price) { self?.update } . else { self?.showError } . finally { self?.buySellView.endRefreshing() }
    }
    
    func update(for price: Float) {
        buySellView.priceValueLabel.attributed.text = "$\(price.maxFractions(2))"
        buySellView.availableLabel.attributed.text = viewModel.availableText
    }
    
    // MARK: Private
    private var buySellView: BuySellView { return view as! BuySellView }
    private let viewModel: BuySellViewModel
    
    private func done() {
        guard let view = view as? BuySellView, let text = view.amountField.text, let amount = Float(text) else {
            alert("Wrong amount value")
            return
        }
        do {
            try viewModel.operate(amount: amount)
            navigationController?.popViewController(animated: true)
        } catch {
            alert(error.localizedDescription)
        }
    }
}

extension BuySellViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let price = viewModel.price.value else { return false }
        let text = (textField.text ?? "") as NSString
        let result = text.replacingCharacters(in: range, with: string)
        if let amount = Float(result), result.count < 10 {
            if amount <= viewModel.maxAmount {
                view.costValueLabel.attributed.text = "$\((price * amount).maxFractions(2))"
            } else {
                DispatchQueue.main.async {
                    let amount = self.viewModel.maxAmount
                    textField.text = String(amount)
                    self.view.costValueLabel.attributed.text = "$\((price * amount).maxFractions(2))"
                    self.view.flashAvailableLabel()
                }
            }
            return true
        } else {
            if result.isEmpty { view.costValueLabel.attributed.text = "0" }            
            return result.isEmpty
        }
    }
}
