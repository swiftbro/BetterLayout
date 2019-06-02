//
//  ColorExtension.swift
//  Trading
//
//  Created by Vlad Che on 1/23/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit

extension UIColor {
    static let tab = TabColors()
    static let text = #colorLiteral(red:0.61, green:0.67, blue:0.75, alpha:1)
    static let lime = #colorLiteral(red:0.02, green:0.69, blue:0.5, alpha:1)
    static let pink = #colorLiteral(red:1, green:0.23, blue:0.45, alpha:1)
    static let view = #colorLiteral(red: 0.03, green: 0.05, blue: 0.2, alpha: 1)
    static let separator = #colorLiteral(red: 0.61, green: 0.67, blue: 0.75, alpha: 1)
    
    struct TabColors {
        var back: UIColor { return #colorLiteral(red: 0.02352941176, green: 0.1725490196, blue: 0.3647058824, alpha: 1) }
        var highlighted: UIColor { return #colorLiteral(red: 0.01568627451, green: 0.5921568627, blue: 0.9098039216, alpha: 1) }
        var tint: UIColor { return #colorLiteral(red: 0.5921568627, green: 0.6549019608, blue: 0.737254902, alpha: 1) }
    }
}
