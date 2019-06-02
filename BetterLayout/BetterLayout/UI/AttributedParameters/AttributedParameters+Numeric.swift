//
//  AttributedParameters+Numeric.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

extension Int {
    var space: AttributedParameters { return AttributedParameters(space: CGFloat(self)) }
    var kern: AttributedParameters { return AttributedParameters(kern: CGFloat(self)) }
    var lines: AttributedParameters { return AttributedParameters(lines: Int(self)) }
}

extension UInt {
    var space: AttributedParameters { return AttributedParameters(space: CGFloat(self)) }
    var kern: AttributedParameters { return AttributedParameters(kern: CGFloat(self)) }
    var lines: AttributedParameters { return AttributedParameters(lines: Int(self)) }
}

extension Double {
    var space: AttributedParameters { return AttributedParameters(space: CGFloat(self)) }
    var kern: AttributedParameters { return AttributedParameters(kern: CGFloat(self)) }
    var lines: AttributedParameters { return AttributedParameters(lines: Int(self)) }
}

extension Float {
    var space: AttributedParameters { return AttributedParameters(space: CGFloat(self)) }
    var kern: AttributedParameters { return AttributedParameters(kern: CGFloat(self)) }
    var lines: AttributedParameters { return AttributedParameters(lines: Int(self)) }
}

extension CGFloat {
    var space: AttributedParameters { return AttributedParameters(space: CGFloat(self)) }
    var kern: AttributedParameters { return AttributedParameters(kern: CGFloat(self)) }
    var lines: AttributedParameters { return AttributedParameters(lines: Int(self)) }
}
