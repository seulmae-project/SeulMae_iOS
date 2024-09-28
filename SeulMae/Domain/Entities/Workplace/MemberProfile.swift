//
//  MemberProfile.swift
//  SeulMae
//
//  Created by 조기열 on 7/20/24.
//

import Foundation

struct MemberProfile: Hashable {
    let name: String
    let phoneNumber: String
    let imageURL: String?
    let joinDate: Date
    let workScheduleList: [WorkSchedule]
    let payDay: Int
    let baseWage: Int
    let memo: String
}
