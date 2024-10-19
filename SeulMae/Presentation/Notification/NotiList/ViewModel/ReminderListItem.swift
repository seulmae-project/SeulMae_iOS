//
//  ReminderListItem.swift
//  SeulMae
//
//  Created by 조기열 on 7/22/24.
//

import UIKit

struct ReminderListItem: Identifiable, Hashable {
    static func category(_ category: String?) -> ReminderListItem {
        var item = ReminderListItem()
        item.section = .category
        item.category = category
        return item
    }

    static func reminder(_ reminder: Reminder?) -> ReminderListItem {
        var item = ReminderListItem()
        item.section = .list
        item.reminder = reminder
        return item
    }

    var id: String = UUID().uuidString
    var section: ReminderListViewController.Section?
    var category: String?
    var reminder: Reminder?

    static var categories: [ReminderListItem] {
        return [
            .category("전체"), .category("가입"), .category("승인"),
        ]
    }
}
