//
//  AttendanceDTO.swift
//  SeulMae
//
//  Created by 조기열 on 11/12/24.
//

import Foundation

struct AttendanceDTO: ModelType {
    let id: Attendance.ID
    let userId: Member.ID
    let userName: String
    let userImageURL: String?
    let workStartDate: Date
    let workEndDate: Date
    let totalWorkTime: Double
    let isRequestApprove: Bool
    let isManagerCheck: Bool?
    let changedWorkStartDate: Date?
    let changedWorkEndDate: Date?

    enum CodingKeys: String, CodingKey {
        case id = "attendanceRequestHistoryId"
        case userId
        case userName
        case userImageURL = "userImageUrl"
        case workStartDate = "workStartTime"
        case workEndDate = "workEndTime"
        case totalWorkTime
        case isRequestApprove
        case isManagerCheck
        case changedWorkStartDate = "changedWorkStartTime"
        case changedWorkEndDate = "changedWorkEndTime"
    }
}

extension BaseResponseDTO<[AttendanceDTO]> {
    func toDomain() -> [Attendance] {
        return data?.map { $0.toDomain() } ?? []
    }
}

extension AttendanceDTO {
    func toDomain() -> Attendance {
        return .init(
            id: id,
            userId: userId,
            username: userName,
            userImageURL: userImageURL ?? "",
            totalWorkTime: totalWorkTime,
            workStartDate: workStartDate,
            workEndDate: workEndDate,
            changedWorkStartDate: changedWorkStartDate,
            changedWorkEndDate: changedWorkEndDate,
            isManagerCheck: isManagerCheck ?? false,
            isRequestApprove: isRequestApprove
        )
    }
}
