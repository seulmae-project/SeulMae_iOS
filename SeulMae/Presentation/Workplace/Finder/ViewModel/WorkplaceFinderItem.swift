//
//  WorkplaceFinderItem.swift
//  SeulMae
//
//  Created by 조기열 on 10/1/24.
//

import UIKit

struct WorkplaceFinderItem: Hashable {
    let identifier: String = UUID().uuidString
    var section: WorkplaceFinderViewController.Section?
    var icon: UIImage?
    var title: String?
    var workplace: Workplace?
    var memberList: [Member]?
    var application: SubmittedApplication?
    var isEmpty: Bool = false
    var notifications: [AppNotification]?

    var message: String {
        if section == .application {
            return "가입 대기중인 근무지가 없습니다"
        } else if section == .workplace {
            return "근무지가 설정 되어 있지 않습니다"
        } else {
            return ""
        }
    }

    var image: UIImage {
        if section == .application {
            return .warning
        } else if section == .workplace {
            return .warning
        } else {
            return UIImage()
        }
    }

    static func reminder(_ notifications: [AppNotification]) -> WorkplaceFinderItem {
        var item = WorkplaceFinderItem()
        item.section = .reminder
        item.notifications = notifications
        return item
    }

    static func application(_ application: SubmittedApplication, workplace: Workplace) -> WorkplaceFinderItem {
        var item = WorkplaceFinderItem()
        item.section = .application
        item.application = application
        item.workplace = workplace
        return item
    }

    static func workplace(_ workplace: Workplace, memberList: [Member]) -> WorkplaceFinderItem {
        var item = WorkplaceFinderItem()
        item.section = .workplace
        item.workplace = workplace
        item.memberList = memberList
        return item
    }

    static func card(title: String, icon: UIImage) -> WorkplaceFinderItem {
        var item = WorkplaceFinderItem()
        item.section = .card
        item.title = title
        item.icon = icon
        return item
    }

    static func empty(section: WorkplaceFinderViewController.Section) -> WorkplaceFinderItem {
        var item = WorkplaceFinderItem()
        item.section = section
        item.isEmpty = true
        return item
    }

    static var cards: [WorkplaceFinderItem] {
        return [
            .card(title: "근무지 검색", icon: .search),
            .card(title: "근무지 생성", icon: .location),
        ]
    }
}
