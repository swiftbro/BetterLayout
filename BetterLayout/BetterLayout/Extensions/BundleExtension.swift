//
//  BundleExtension.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

public extension Bundle {
    public static var current: Bundle { return Bundle(for: BundleToken.self) }
    
    public func image(_ imageFromLiteral: ImageFromLiteral) -> UIImage? {
        return imageFromLiteral.image(in: self)
    }
}

fileprivate class BundleToken {}

public struct ImageFromLiteral: _ExpressibleByImageLiteral {
    
    public init(imageLiteralResourceName name: String) {
        self.name = name
    }
    
    func image(in bundle: Bundle) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
    
    private let name: String
}
