//
//  NotiListItem.swift
//  SeulMae
//
//  Created by 조기열 on 7/22/24.
//

import UIKit

struct NotiListItem: Hashable, Identifiable {
    enum ItemType {
        // TODO: Section 이랑 다를 게 뭐지..?
        case category, noti
    }
    
    var type: ItemType
    var id: String
    var noti: AppNotification?
    var category: String?
    
    init(cateogry: String) {
        self.type = .category
        self.id = UUID().uuidString
        self.noti = nil
        self.category = cateogry
    }
    
    init(noti: AppNotification) {
        self.type = .noti
        self.id = UUID().uuidString
        self.noti = noti
        self.category = ""
    }
}

struct Category {
    let title: String
    let color: UIColor
    // let isSelected: 
}
