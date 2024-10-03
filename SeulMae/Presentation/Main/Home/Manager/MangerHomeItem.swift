//
//  MangerHomeItem.swift
//  SeulMae
//
//  Created by 조기열 on 10/3/24.
//

import Foundation

struct ManagerHomeItem: Identifiable, Hashable {
    enum ItemType: Hashable {
        case status
        case list
    }
    
    let id = UUID().uuidString
    let type: ItemType
    let leftRequestCount: Int?
    let doneRequestCount: Int?
    let listItem: [ManagerHomeListItem]?
    
    init(leftCount: Int, doneCount: Int) {
        self.type = .status
        self.leftRequestCount = leftCount
        self.doneRequestCount = doneCount
        self.listItem = nil
    }
    
    init(listItem: [ManagerHomeListItem]) {
        self.type = .list
        self.leftRequestCount = nil
        self.doneRequestCount = nil
        Swift.print("[HomeItem]: \(listItem)")
        self.listItem = listItem
    }
}
