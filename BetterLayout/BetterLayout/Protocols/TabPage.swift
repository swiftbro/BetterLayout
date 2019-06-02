//
//  BarPage.swift
//  Trading
//
//  Created by Vladimir Kravchenko on 2/15/19.
//  Copyright © 2019 Digicode. All rights reserved.
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
