//
//  BonusData.swift
//  Trading
//
//  Created by Vladimir Kravchenko on 3/26/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import Foundation

struct BonusData: Codable {
    let title: String
    let menuItems: [MenuItem]
    let stripCode: Strip
    let entryFlow: Flow
    
    struct MenuItem: Codable {
        let title: String
        let pageItems: [PageItem]
        let image: String
        
        struct PageItem: Codable {
            let url: String
            let image: String
            let cfaText: String
            let title: String
            let rating: Float
            let description: String
        }
    }
    
    struct Strip: Codable {
        let type: StripType
        let payload: String
        
        enum StripType: String, Codable {
            case iframe
        }
    }
    
    struct Flow: Codable {
        let menuText: Menu
        let goto: Goto
        
        struct Menu: Codable {
            let app: String
            let sdk: String
        }
        
        enum Goto: String, Codable {
            case menu, app, sdk
        }
    }
}
