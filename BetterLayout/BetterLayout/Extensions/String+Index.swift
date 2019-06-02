//
//  String+Index.swift
//  Trading
//
//  Created by Vladimir Kravchenko on 3/13/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import Foundation

extension String {
    func startIndex(ofFirst: String) -> String.Index? {
        return startIndex(of: ofFirst, after: startIndex)
    }
    
    func endIndex(ofFirst: String) -> String.Index? {
        return endIndex(of: ofFirst, after: startIndex)
    }
    
    func startIndex(ofLast: String) -> String.Index? {
        return startIndex(of: ofLast, before: endIndex)
    }
    
    func endIndex(ofLast: String) -> String.Index? {
        return endIndex(of: ofLast, before: endIndex)
    }
    
    func startIndex(of: String, after: String.Index) -> String.Index? {
        return range(of: of, after: after)?.lowerBound
    }
    
    func endIndex(of: String, after: String.Index) -> String.Index? {
        return range(of: of, after: after)?.upperBound
    }
    
    func startIndex(of: String, before: String.Index) -> String.Index? {
        return range(of: of, before: before)?.lowerBound
    }
    
    func endIndex(of: String, before: String.Index) -> String.Index? {
        return range(of: of, before: before)?.upperBound
    }
    
    func firstRange(of: String) -> Range<String.Index>? {
        return range(of: of, after: startIndex)
    }
    
    func lastRange(of: String) -> Range<String.Index>? {
        return range(of: of, before: endIndex)
    }
    
    func range(of: String, after: String.Index) -> Range<String.Index>? {
        return range(of: of, options: .caseInsensitive, range: after ..< endIndex)
    }
    
    func range(of: String, before: String.Index) -> Range<String.Index>? {
        return range(of: of, options: [.backwards, .caseInsensitive], range: startIndex ..< before)
    }
}

extension Int {
    var symbol: String.IndexOperation {
        return String.IndexOperation(base: .first, term: self)
    }
}

extension String {
    static func + (lhs: String, rhs: Int) -> String.IndexOperation {
        return String.IndexOperation(base: .search(lhs), term: rhs)
    }
    
    static func - (lhs: String, rhs: Int) -> String.IndexOperation {
        return String.IndexOperation(base: .search(lhs), term: -rhs)
    }
}

extension String {
    
    func index(_ operation: String.IndexOperation) -> String.Index? {
        guard let stringIndex = operation.index(for: self) else { return nil }
        return index(stringIndex, offsetBy: operation.term)
    }
    
    func range(of operation: String.IndexOperation) -> Range<String.Index>? {
        return operation.range(for: self)
    }
    
    var start: String.IndexOperation { return String.IndexOperation(base: .search(self), term: 0) }
    var end: String.IndexOperation { return String.IndexOperation(base: .search(self), term: 0) }
    
    enum IndexBase {
        case first
        case last
        case search(String)
    }
    
    struct IndexOperation: ExpressibleByStringLiteral {
        let base: String.IndexBase
        let term: Int
        
        static var first = String.IndexOperation(base: .first, term: 0)
        static var last = String.IndexOperation(base: .last, term: 0)
        
        init(stringLiteral value: String) {
            self.base = .search(value)
            self.term = 0
        }
        
        init(base: String.IndexBase, term: Int) {
            self.base = base
            self.term = term
        }
        
        func index(for string: String) -> String.Index? {
            switch (base, term) {
            case (.first, 0...): return string.startIndex
            case (.last, ...0): return string.index(before: string.endIndex)
            case (.search(let s), ..<0): return string.startIndex(ofFirst: s)
            case (.search(let s), 0...):
                guard let index = string.endIndex(ofFirst: s) else {return nil}
                return string.index(before: index)
            default: return nil
            }
        }
        
        func range(for string: String) -> Range<String.Index>? {
            let start = string.startIndex
            let end = string.endIndex
            switch (base, term) {
            case (.first, 0...): return start ..< string.index(start, offsetBy: term + 1)
            case (.last, ...0): return string.index(end, offsetBy: term) ..< string.index(after: end)
            case (.search(let s), 0...):
                guard let index = string.endIndex(ofFirst: s) else {return nil}
                return string.index(after: index) ..< string.index(index, offsetBy: term + 1)
            case (.search(let s), ..<0):
                guard let index = string.startIndex(ofFirst: s) else {return nil}
                return string.index(index, offsetBy: term) ..< index
            default: return nil
            }
        }
    }
}

extension String.IndexOperation {
    static func + (lhs: String.IndexOperation, rhs: Int) -> String.IndexOperation {
        return String.IndexOperation(base: lhs.base, term: lhs.term + rhs)
    }
    
    static func - (lhs: String.IndexOperation, rhs: Int) -> String.IndexOperation {
        return String.IndexOperation(base: lhs.base, term: lhs.term - rhs)
    }
}

func testStringOperation() {
    let string = "0123456789"
    let five = "5"
    
    guard
        let a = string.index("12" + 1),
        let b = string.index("12" - 1),
        let c = string.index(five + 1),
        let d = string.index(five - 1),
        let e = string.index(5.symbol)
        else {
            assertionFailure("Index is out of bounds")
            return
    }
    
    assert(string.index(.first) == string.startIndex, "First is incorrect")
    assert(string.index(.last) == string.index(string.endIndex, offsetBy: -1), "Last is incorrect")
    assert(string.index(.first + 1) == string.index(after: string.startIndex), "After first is incorrect")
    assert(string.index(.last - 1) == string.index(string.endIndex, offsetBy: -2), "Before last is incorrect")
    
    assert(string[a] == "3", "After literal is incorrect")
    assert(string[b] == "0", "Before literal is incorrect")
    assert(string[c] == "6", "After string is incorrect")
    assert(string[d] == "4", "Before string is incorrect")
    assert(string[e] == "5", "Subscript is incorrect")
}
