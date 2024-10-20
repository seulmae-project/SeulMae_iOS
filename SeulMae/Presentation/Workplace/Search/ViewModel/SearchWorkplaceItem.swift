//
//  SearchWorkplaceItem.swift
//  SeulMae
//
//  Created by 조기열 on 9/29/24.
//

import Foundation

struct SearchWorkplaceItem: Hashable {
    static func category(_ category: String) -> SearchWorkplaceItem {
        var item = SearchWorkplaceItem()
        item.section = .category
        item.category = category
        return item
    }

    static func query(_ query: String) -> SearchWorkplaceItem {
        var item = SearchWorkplaceItem()
        item.section = .list
        item.query = query
        return item
    }

    let id: String = UUID().uuidString
    var section: SearchWorkplaceViewController.Section?
    var category: String?
    var query: String?

    static var categories: [Self] {
        return [
            .category("최근 검색")
        ]
    }
}
