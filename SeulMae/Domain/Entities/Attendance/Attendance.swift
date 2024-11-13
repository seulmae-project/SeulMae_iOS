//
//  Attendance.swift
//  SeulMae
//
//  Created by 조기열 on 11/12/24.
//

import Foundation

struct Attendance: Identifiable, Hashable {
    let id: Int
    let userId: Member.ID
    let username: String
    let userImageURL: String
    let totalWorkTime: Double
    let workStartDate: Date
    let workEndDate: Date
    let changedWorkStartDate: Date?
    let changedWorkEndDate: Date?
    let isManagerCheck: Bool
    let isRequestApprove: Bool
}
