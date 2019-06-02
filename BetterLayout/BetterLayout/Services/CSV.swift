//
//  CSV.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import Foundation

class CSV {
    
    typealias Item = (code: String, name: String)
    
    private let csvString: String
    
    init(name: String) throws {
        let url = try Bundle.current.url(forResource: name, withExtension: nil).orThrow("Resource not found for this name")
        csvString = try String(contentsOf: url)
    }
    
    func findOccurences(of string: String) -> [Item] {
        let lines = csvString.components(separatedBy: "\r\n")
        let matches = lines.filter { $0.contains(string, options: .caseInsensitive) }
        return matches.compactMap { line in
            let components = line.components(separatedBy: ",")
            guard let code = components.first, let name = components.last else { return nil }
            return (code, name)
        }
    }
}
