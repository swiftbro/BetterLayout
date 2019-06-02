//
//  StringExtensions.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import Foundation
import SwiftDate

extension String: Error {
    public var localizedDescription: String {
        return self
    }
}

extension RawRepresentable where RawValue == String {
    var string: String {
        return rawValue
    }
}

extension String {
    var date: Date? {
        return toDate(["yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd"], region: SwiftDate.defaultRegion)?.date
    }
}

extension String {
    func contains(_ string: String, options: String.CompareOptions) -> Bool {
        if options == .caseInsensitive {
            return lowercased().contains(string.lowercased())
        }
        return contains(string)
    }
}

extension NSParagraphStyle {
    static func with(_ configure: (NSMutableParagraphStyle) -> Void) -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        configure(paragraphStyle)
        return paragraphStyle.copy()
    }
}

extension Int {
    init?(_ character: Character) {
        self.init(String(character))
    }
}

extension Float {
    func maxFractions(_ count: Int) -> String {
        return Double(self).maxFractions(count)
    }
}

extension Double {
    func maxFractions(_ count: Int) -> String {
        let number = NSNumber(value: self)
        let formatter = NumberFormatter()
        
        formatter.minimumIntegerDigits = 1
        
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = count
        
        if self < 1 {
            formatter.usesSignificantDigits = true
            formatter.maximumSignificantDigits = count
        }
        
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        if var string = formatter.string(from: number) {
            let components = string.components(separatedBy: ".")
            if components.count > 1, let last = components.last {
                if last.count == 1 { string += "0" }
                if last.count > 4 { return components.first! + "." + "001" }
            }
            return string
        } else {
            return ""
        }
    }
}

typealias L = L10n

extension Region {
    static var EST: Region {
        return Region(calendar: Calendar.autoupdatingCurrent, zone: TimeZone(identifier: "EST")!, locale: Locale.autoupdatingCurrent)
    }
}

func testFloatToString() {
    assert(100000.0.maxFractions(2) == "100,000", "No commas")
    assert(100000.2.maxFractions(2) == "100,000.20", "No trailing zero")
    assert(100000.002.maxFractions(2) == "100,000", "Round is incorrect")
    assert(100000.006.maxFractions(2) == "100,000.01", "Round is incorrect")
    assert(0.000000555000021321321.maxFractions(2) == "0.00000056", "Round is incorrect")
}
