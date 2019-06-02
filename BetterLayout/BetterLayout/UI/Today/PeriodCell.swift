//
//  PeriodCell.swift
//  Trading
//
//  Created by Vlad Che on 2/24/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit
import Reusable

class PeriodCell: Item, Reusable {
    let label = UILabel()
    let view = UIView()
    
    func setup() {
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        label.set(font: .systemFont(ofSize: 14), color: #colorLiteral(red:0.61, green:0.67, blue:0.75, alpha:1), space: 1.14)
    }
    
    func arrangeSubviews() {
        contentView.addSubview(view)
        view.addSubview(label)
        
        view.layout(.center)
        label.layout(15.leading.trailing, 4.top.bottom)
    }
}
