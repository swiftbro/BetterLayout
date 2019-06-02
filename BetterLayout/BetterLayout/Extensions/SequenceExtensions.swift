//
//  CollectionExtensions.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Sequence {
    /// Returns an array containing the values for specified key path.
    ///
    /// - Parameter keyPath: key path to property
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return self.map { $0[keyPath: keyPath] }
    }
    
    public func flatMap<T>(_ keyPath: KeyPath<Element.Element, T>) -> [T] where Element: Sequence {
        return self.flat.map { $0[keyPath: keyPath] }
    }
    
    /// Returns an array containing the non-nil values for specified key path.
    ///
    /// - Parameter keyPath: key path to property
    func compactMap<T>(_ keyPath: KeyPath<Element, T?>) -> [T] {
        return self.compactMap { $0[keyPath: keyPath] }
    }
    
    /// Returns an array without nil objects
    func compact<T>() -> [T] where Element == Optional<T> {
        return compactMap{ $0 }
    }
}

extension Sequence where Element: Sequence {
    /// Returns a single-level collection
    var flat: [Element.Element] { return  flatMap { $0 } }
}

extension Collection where Element: Equatable {
    /// Returns an array with unique objects
    var orderedSet: [Element]  {
        var array: [Element] = []
        return compactMap {
            if array.contains($0) {
                return nil
            } else {
                array.append($0)
                return $0
            }
        }
    }
}
