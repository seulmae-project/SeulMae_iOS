//
//  UserHomeItem.swift
//  SeulMae
//
//  Created by 조기열 on 10/13/24.
//

import Foundation

struct UserHomeItem: Hashable {
    let section: UserHomeViewController.Section
    let histories: [AttendanceHistory]?
    let placeList: [Workplace]?

    // let workplaceStatus

    init(workplace: Workplace, profile: MemberProfile) {
        self.section = .status
        self.histories = nil
        self.placeList = nil
    }

    init(histories: [AttendanceHistory]) {
        self.section = .calendar
        self.histories = histories
        self.placeList = nil
    }

    init(placeList: [Workplace]) {
        self.section = .list
        self.histories = nil
        self.placeList = placeList
    }
}
