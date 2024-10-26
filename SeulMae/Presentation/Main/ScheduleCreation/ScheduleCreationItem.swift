//
//  ScheduleCreationItem.swift
//  SeulMae
//
//  Created by 조기열 on 10/26/24.
//

import Foundation

struct ScheduleCreationItem: Hashable {
    let id: String = UUID().uuidString
    let member: Member

    init(member: Member) {
        self.member = member
    }
}
