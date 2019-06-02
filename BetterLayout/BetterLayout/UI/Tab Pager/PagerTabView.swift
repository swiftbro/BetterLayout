//
//  PagerTabView.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PagerTabView: View {
    let buttonsView: ButtonBarView = .default
    let scrollView: UIScrollView = UIScrollView(frame: .zero)
    
    func setup() {
        buttonsView.backgroundColor = #colorLiteral(red:0.03, green:0.13, blue:0.27, alpha:1)
        backgroundColor = .view
    }
    
    func arrangeSubviews() {
        addSubview(buttonsView)
        addSubview(scrollView)
        buttonsView.layout(44.height, pin.top[.safearea], .leading, .trailing)
        scrollView.layout(.left, .right, just.below[buttonsView], layoutMarginsGuide.bottom)
    }
    
    //MARK: - Private
}

extension ButtonBarView {
    static var `default`: ButtonBarView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return ButtonBarView(frame: .zero, collectionViewLayout: layout)
    }
}
