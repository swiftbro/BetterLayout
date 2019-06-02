//
//  UIButton+Attributes.swift
//  Trading
//
//  Created by Vladimir Kravchenko on 3/26/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(title: String? = nil, font: UIFont? = nil, color: UIColor? = nil,
                     align: UIControl.ContentHorizontalAlignment = .center, backColor: UIColor? = nil, radius: CGFloat = 0) {
        self.init(type: .custom)
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        titleLabel?.font = font
        contentHorizontalAlignment = align
        backgroundColor = backColor
        layer.cornerRadius = radius
    }
}
