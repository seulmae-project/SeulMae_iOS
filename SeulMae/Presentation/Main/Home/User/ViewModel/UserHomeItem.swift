//
//  UserHomeItem.swift
//  SeulMae
//
//  Created by 조기열 on 10/13/24.
//

import Foundation

struct UserHomeItem: Identifiable, Hashable {
    let id: String = UUID().uuidString
    let section: UserHomeViewController.Section
    let profile: MemberProfile?
    let workplace: Workplace?
    let histories: [AttendanceHistory]?

    init(profile: MemberProfile, workplace: Workplace) {
        self.section = .status
        self.profile = profile
        self.workplace = workplace
        self.histories = nil
    }

    init(histories: [AttendanceHistory]) {
        self.section = .calendar
        self.profile = nil
        self.workplace = nil
        self.histories = histories
    }

    init(workplace: Workplace) {
        self.section = .list
        self.profile = nil
        self.workplace = workplace
        self.histories = nil
    }
}
