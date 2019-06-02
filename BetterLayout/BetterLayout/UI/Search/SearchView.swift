//
//  SearchView.swift
//  Trading
//
//  Created by Vlad Che on 2/26/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit

class SearchView: View {
    let searchField = UITextField()
    let searchIcon = UIImageView(image: #imageLiteral(resourceName: "searchicon"))
    let searchContainer = UIView()
    let searchCleanButton = UIButton(type: .custom)
    let tableView = UITableView.default
    
    func arrangeSubviews() {
        addSubviews(searchContainer, tableView)
        searchContainer.addSubviews(searchIcon, searchField, searchCleanButton)
        
        searchContainer.layout(16.leading.trailing, 8.top, 36.height)
        tableView.layout(just.below[searchContainer], layoutMarginsGuide.bottom, zero.leading.trailing)
        
        searchIcon.layout(14.height.width, 8.leading, exact.centerY)
        searchField.layout(22.height, exact.centerY, 7.leading.to(searchIcon), 7.trailing.to(searchCleanButton))
        searchCleanButton.layout(45.height.width, .trailing, exact.centerY)
    }
    func setup() {
        backgroundColor = #colorLiteral(red:0.03, green:0.05, blue:0.2, alpha:1)
        searchContainer.backgroundColor = #colorLiteral(red:0.56, green:0.56, blue:0.58, alpha:0.31)
        searchContainer.layer.cornerRadius = 8
        searchField.font = .regular-17
        searchField.textColor = #colorLiteral(red:0.61, green:0.67, blue:0.75, alpha:1)
        searchField.textPlaceholder = L.Search.placeholder
        searchCleanButton.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        searchCleanButton.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        searchCleanButton.contentMode = .center
        tableView.backgroundColor = #colorLiteral(red:0.03, green:0.05, blue:0.2, alpha:1)
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

}
