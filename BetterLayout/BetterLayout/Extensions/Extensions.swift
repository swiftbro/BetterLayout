//
//  Extensions.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

extension NSCopying {
    func copy<T: NSCopying>() -> T {
        return copy(with: nil) as! T
    }
}

extension Optional {
    func orThrow(_ errorExpression: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else {
            throw errorExpression()
        }
        return value
    }
}

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        if case let .some(value) = self, !value.isEmpty { return false }
        return true
    }
}

extension UICollectionViewLayout {
    static var hotizontal: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }
}

extension UIDevice {
    static var isPhone: Bool { return UIDevice.current.userInterfaceIdiom == .phone }
    static var isPad: Bool { return UIDevice.current.userInterfaceIdiom == .pad }
    static var isXS: Bool { return isPhone && UIScreen.main.nativeBounds.height == 2436 }
    static var isXSMax: Bool { return isPhone && UIScreen.main.nativeBounds.height == 2688 }
    static var isXR: Bool { return isPhone && UIScreen.main.nativeBounds.height == 1792 }
    static var isX: Bool { return isXS || isXSMax || isXR }
    static var isPlus: Bool { return isPhone && (UIScreen.main.nativeBounds.height == 1920 || UIScreen.main.nativeBounds.height == 2208) }
    
    func printModel() {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("IPHONE 5,5S,5C")
            case 1334:
                print("IPHONE 6,7,8 IPHONE 6S,7S,8S ")
            case 1920, 2208:
                print("IPHONE 6PLUS, 6SPLUS, 7PLUS, 8PLUS")
            case 2436:
                print("IPHONE X, IPHONE XS")
            case 2688:
                print("IPHONE XS_MAX")
            case 1792:
                print("IPHONE XR")
            default:
                print("UNDETERMINED")
            }
        }
    }
}
