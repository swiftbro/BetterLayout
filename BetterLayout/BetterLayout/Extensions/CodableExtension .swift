//
//  CodableExtension .swift
//  Trading
//
//  Created by Vladimir Kravchenko on 1/30/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import Foundation

extension JSONDecoder {
    static var convertFromSnake: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

struct AnyKey: CodingKey, Hashable, CustomStringConvertible {
    var stringValue: String
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int?
    
    init?(intValue: Int) {
        self.stringValue = String(intValue)
    }
}

extension KeyedDecodingContainer where K == AnyKey {
    func decode<T>(_ keyContains: String) throws -> T where T: Decodable {
        return try decode(T.self, forKeyContains: keyContains)
    }
    
    func decode<T>(_ type: T.Type, forKeyContains key: String) throws -> T where T : Decodable {
        if key.isEmpty, let codingKey = allKeys.first {
            return try decode(type, forKey: codingKey)
        }
        if let codingKey = allKeys.first(where: { $0.stringValue.contains(key, options: .caseInsensitive) }) {
            return try decode(type, forKey: codingKey)
        } else {
            throw keyNotFound(key)
        }
    }
    
    func decodeKeyedElements<Element: Decodable>(_ keyContains: String) throws -> [Element] {
        let titles = try nestedContainer(keyedBy: AnyKey.self, forKeyContains: keyContains)
        return try titles.allKeys.map { title in
            return try titles.decode(Element.self, forKey: title)
        }
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKeyContains key: String) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        if let codingKey = allKeys.first(where: { $0.stringValue.contains(key, options: .caseInsensitive) }) {
            return try nestedContainer(keyedBy: type, forKey: codingKey)
        } else {
            throw keyNotFound(key)
        }
    }
    
    func nestedUnkeyedContainer(forKeyContains key: String) throws -> UnkeyedDecodingContainer {
        if let codingKey = allKeys.first(where: { $0.stringValue.contains(key, options: .caseInsensitive) }) {
            return try nestedUnkeyedContainer(forKey: codingKey)
        } else {
            throw keyNotFound(key)
        }
    }
    
    func firstKey() throws -> CodingKey {
        return try allKeys.first.orThrow(noKeyError)
    }
    
    var noKeyError: DecodingError {
        let debugDescription = "No key was found / Not a keyed container"
        return DecodingError.typeMismatch(String.self, errorContext(with: debugDescription))
    }
    
    func keyNotFound(_ key: String) -> DecodingError {
        let debugDescription = "Can't find a key that contains `\(key)`.\n All keys: \(allKeys.map(\.stringValue))"
        return DecodingError.keyNotFound(AnyKey(stringValue: key)!, errorContext(with: debugDescription))
    }
    
    func errorContext(with debugDescription: String) -> DecodingError.Context {
        return DecodingError.Context(codingPath: self.codingPath, debugDescription: debugDescription)
    }
}

extension Decoder {
    func currentKey() throws -> String {
        guard let key = codingPath.last as? AnyKey else {
            throw DecodingError.dataCorrupted(.init(codingPath: codingPath,
                                                    debugDescription: "Not in titled container"))
        }
        return key.stringValue
    }
    
    func decodeKeyedElements<Element: Decodable>(_ type: Element.Type) throws -> [Element] {
        let titles = try container(keyedBy: AnyKey.self)
        return try titles.allKeys.map { title in
            return try titles.decode(Element.self, forKey: title)
        }
    }
}

extension Decoder {
    func decode<T>(_ keyContains: String) throws -> T where T: Decodable {
        return try decode(T.self, forKeyContains: keyContains)
    }
    
    func decode<T>(_ type: T.Type, forKeyContains key: String) throws -> T where T : Decodable {
        let container = try self.container(keyedBy: AnyKey.self)
        return try container.decode(type, forKeyContains: key)
    }
    
    func firstKey() throws -> CodingKey {
        let container = try self.container(keyedBy: AnyKey.self)
        return try container.firstKey()
    }
}

protocol StringKey: RawRepresentable where RawValue == String { }
