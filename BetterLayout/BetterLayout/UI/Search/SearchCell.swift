//
//  SearchCell.swift
//  Trading
//
//  Created by Vlad Che on 2/27/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit
import Reusable

class SearchCell: Cell, Reusable {
    let nameLabel = UILabel()
    let infoLabel = UILabel()
    let addButton = UIButton(align: .right)
    
    func arrangeSubviews() {
        contentView.addSubviews(nameLabel, infoLabel, addButton)
        
        nameLabel.layout(16.leading, 22.top, 8.trailing[addButton])
        infoLabel.layout(8.below[nameLabel], 16.leading, 22.bottom, 8.trailing[addButton])
        addButton.layout(50.width, .height, 16.trailing, nameLabel.centerY)
    }
    
    func setup() {
        backgroundColor = #colorLiteral(red:0.03, green:0.05, blue:0.2, alpha:1)
        nameLabel.set(font: .semibold-20, color: .white, space: 1.2)
        infoLabel.set(font: .regular, color: #colorLiteral(red:0.61, green:0.67, blue:0.75, alpha:1))
        addButton.setImage(#imageLiteral(resourceName: "add"), for: .normal)        
        if UIDevice.isPad { selectionStyle = .blue } else { selectionStyle = .none }
    }
}
