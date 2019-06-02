//
//  UIButton+Attributes.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
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
