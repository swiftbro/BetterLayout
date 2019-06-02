//
//  BuySellView.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

class BuySellView: View {
    let scrollView = UIScrollView()
    let availableLabel = UILabel()
    let amountLabel = UILabel()
    let amountField = UITextField()
    let priceLabel = UILabel()
    let priceValueLabel = UILabel()
    let costLabel = UILabel()
    let costValueLabel = UILabel()
    let doneButton = UIButton(type: .custom)
    let refresher = UIRefreshControl()
    
    func endRefreshing() {
        refresher.endRefreshing()
        scrollView.subviews.forEach { $0.isHidden = false }
    }
    
    func beginRefreshing() {
        scrollView.contentOffset = CGPoint(x: 0, y: -self.refresher.frame.height)
        refresher.beginRefreshing()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = CGSize(width: scrollView.frame.width,
                                        height: scrollView.frame.height + self.refresher.frame.height)
    }
    
    func arrangeSubviews() {
        let amountSeparator = UIView { $0.backgroundColor = #colorLiteral(red:0.02, green:0.62, blue:0.94, alpha:1) }
        let priceSeparator = UIView { $0.backgroundColor = #colorLiteral(red:0.02, green:0.62, blue:0.94, alpha:1) }
        let x = UIImageView(image: #imageLiteral(resourceName: "cancel"))
        
        addSubviews(scrollView.with(availableLabel,
                                    amountLabel, amountField, amountSeparator,
                                    priceLabel, x, priceValueLabel, priceSeparator,
                                    costLabel, costValueLabel,
                                    doneButton))
        scrollView.layout(.edges, to: .safearea)
        16.leading.constraint(for: availableLabel, amountLabel, amountSeparator,
                              priceLabel, priceSeparator, costLabel, to: .safearea)
        16.trailing.constraint(for: availableLabel, amountField, amountSeparator,
                               priceValueLabel, priceSeparator, costValueLabel, to: .safearea)
        availableLabel.layout(24.top)
        amountLabel.layout(89.below[availableLabel], 10.trailing, .centerY, to: amountField)
        amountField.layout(≥50.width)
        amountSeparator.layout(1.height, 8.below[amountLabel])
        priceLabel.layout(35.below[amountSeparator], priceValueLabel.centerY)
        x.layout(8.width.height, priceValueLabel.before, scrollView.centerX, priceLabel.centerY.after)
        priceSeparator.layout(1.height, 8.below[priceLabel])
        costLabel.layout(35.below[priceSeparator], ≥10.trailing, .centerY, to: costValueLabel)
        doneButton.layout(56.height, .bottom, .leading, .trailing, to: .safearea)
    }
    
    func setup() {
        scrollView.keyboardDismissMode = .onDrag
        scrollView.delegate = self
        scrollView.refreshControl = refresher
        refresher.tintColor = #colorLiteral(red:0.02, green:0.69, blue:0.5, alpha:1)
        scrollView.subviews.forEach { $0.isHidden = true }
                
        availableLabel.set(font: .medium-16, color: #colorLiteral(red:0.61, green:0.67, blue:0.75, alpha:1), lines: 2, space: 1.2)
        [amountLabel, priceLabel, costLabel].forEach { $0.set(font: .semibold-18, color: #colorLiteral(red:0.02, green:0.62, blue:0.94, alpha:1), space: 1.22) }
        costLabel.attributed.color = #colorLiteral(red:0.61, green:0.67, blue:0.75, alpha:1)
        costValueLabel.set(font: .regular-24, color: .white, align: .right, space: 1.21)
        priceValueLabel.set(font: .regular-18, color: #colorLiteral(red:0.61, green:0.67, blue:0.75, alpha:1), align: .right, space: 1.22)
        amountField.font = .regular-24
        amountField.textColor = .white
        amountField.textAlignment = .right
        amountField.keyboardType = .decimalPad
        amountField.textPlaceholder = "0"
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditing(_:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    func flashAvailableLabel() {
        UIView.transition(with: availableLabel, duration: 1.0, options: .transitionCrossDissolve,
                          animations: { self.availableLabel.attributed.color = #colorLiteral(red:1, green:0.23, blue:0.45, alpha:1) }) { _ in
        UIView.transition(with: self.availableLabel, duration: 0.3, options: .transitionCrossDissolve,
                         animations: { self.availableLabel.attributed.color = #colorLiteral(red:0.61, green:0.67, blue:0.75, alpha:1) })
        }
    }
}

extension BuySellView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            scrollView.setContentOffset(.zero, animated: false)
        }
    }
}
