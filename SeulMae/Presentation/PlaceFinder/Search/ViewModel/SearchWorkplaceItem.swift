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
        item.section = .history
        item.category = category
        return item
    }

    static func query(_ query: Workplace) -> SearchWorkplaceItem {
        var item = SearchWorkplaceItem()
        item.section = .list
        item.query = query.name
        item.workplaceId = query.id
        return item
    }

    static func empty(_ message: String) -> SearchWorkplaceItem {
        var item = SearchWorkplaceItem()
        item.section = .list
        item.emptyMessage = message
        item.isEmpty = true
        return item
    }

    let id: String = UUID().uuidString
    var section: SearchWorkplaceViewController.Section?
    var category: String?
    var query: String?
    var workplaceId: Int?
    var isEmpty: Bool = false
    var emptyMessage: String?

    static var categories: [Self] {
        return [
            .category("최근 검색")
        ]
    }

    static var emtpy: [Self] {
        return [
            .empty("최근 검색한 내역이 없습니다")
        ]
    }
}
