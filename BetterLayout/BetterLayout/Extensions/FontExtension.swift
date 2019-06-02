//
//  FontExtension.swift
//  Trading
//
//  Created by Vlad Che on 2/24/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit

extension UIFont {
    static func - (lhs: UIFont, rhs: CGFloat) -> UIFont {
        return lhs.withSize(rhs)
    }
    
    subscript(size: CGFloat) -> UIFont {
        get { return self.withSize(size) }
    }
    
    static var defaultSize: CGFloat { return 14 }
    
    static var regular: UIFont {
        return UIFont(name: "Montserrat-Regular", size: defaultSize)
            ?? .systemFont(ofSize: defaultSize, weight: .regular)
    }
    
    static var medium: UIFont {
        return UIFont(name: "Montserrat-Medium", size: defaultSize)
            ?? .systemFont(ofSize: defaultSize, weight: .medium)
    }
    
    static var semibold: UIFont {
        return UIFont(name: "Montserrat-SemiBold", size: defaultSize)
            ?? .systemFont(ofSize: defaultSize, weight: .semibold)
    }
}
