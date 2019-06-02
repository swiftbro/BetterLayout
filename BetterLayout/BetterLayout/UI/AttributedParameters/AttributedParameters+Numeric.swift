//
//  AttributedParameters+Numeric.swift
//  Trading
//
//  Created by Vladimir Kravchenko on 3/15/19.
//  Copyright © 2019 Digicode. All rights reserved.
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
