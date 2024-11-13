//
//  AttendanceHistory.swift
//  SeulMae
//
//  Created by 조기열 on 9/13/24.
//

import Foundation

struct AttendanceHistory: Identifiable, Hashable {
    let id: Int // idAttendanceRequestHistory
    let workDate: Date
    let workStartTime: Date
    let workEndTime: Date
    let totalWorkTime: Double
    let wage: Double
    let isRequestApprove: Bool
    let isManagerCheck: Bool
}
