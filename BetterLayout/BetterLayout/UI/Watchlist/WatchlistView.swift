//
//  WatchlistView.swift
//  Trading
//
//  Created by Vlad Che on 1/23/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit

class WatchlistView: View {
    let tableView = UITableView.default
    
    func setup() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func arrangeSubviews() {
        addSubview(tableView)
        tableView.layout(.edges)
    }
}
