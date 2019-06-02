//
//  WatchlistView.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
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
