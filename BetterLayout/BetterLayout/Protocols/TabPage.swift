//
//  BarPage.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import Foundation
import XLPagerTabStrip

public protocol TabPage: IndicatorInfoProvider {
    var indicator: String {get}
}

extension TabPage {
    public func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: indicator)
    }
}
