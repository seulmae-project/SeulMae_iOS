//
//  NotiListItem.swift
//  SeulMae
//
//  Created by 조기열 on 7/22/24.
//

import UIKit

struct NotiListItem: Hashable, Identifiable {
    enum ItemType {
        case notice, remainder
    }
    
    var type: ItemType
    var id: Int
    var icon: UIImage
    var title: String
    var body: String
    
    init(notice: Notice) {
        self.type = .notice
        self.id = notice.id
        self.title = notice.title
        self.body = notice.content ?? ""
        self.icon = .actions
    }
    
//    init(notice: Notice) {
//        self.type = .notice
//        self.id = notice.id
//        self.title = notice.title
//        self.body = notice.content ?? ""
//        self.icon = .actions
//    }
    
    // var icon:
}
