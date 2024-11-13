//
//  AttendanceHistoryDTO.swift
//  SeulMae
//
//  Created by 조기열 on 11/13/24.
//

import Foundation

struct AttendanceHistoryDTO: ModelType {
    let id: Int
    let workDate: Date
    let workStartTime: Date?
    let workEndTime: Date?
    let totalWorkTime: Double?
    let wage: Double?
    let isRequestApprove: Bool
    let isManagerCheck: Bool

    enum CodingKeys: String, CodingKey {
        case id = "idAttendanceRequestHistory"
        case workDate
        case workStartTime
        case workEndTime
        case totalWorkTime
        case wage
        case isRequestApprove
        case isManagerCheck
//        "unconfirmedWage" : 0,
//        "confirmedWage" : 0,
    }
}

extension BaseResponseDTO<AttendanceHistoryDTO> {
    func toDomain() -> AttendanceHistory? {
        return data?.toDomain()
    }
}

extension BaseResponseDTO<[AttendanceHistoryDTO]> {
    func toDomain() -> [AttendanceHistory] {
        return data?.map { $0.toDomain() } ?? []
    }
}

extension [AttendanceHistoryDTO] {
    func toDomain() -> [AttendanceHistory] {
        return map { $0.toDomain() }
    }
}

extension AttendanceHistoryDTO {
    func toDomain() -> AttendanceHistory {
        return AttendanceHistory(
            id: self.id,
            workDate: self.workDate,
            workStartTime: self.workStartTime ?? Date(),
            workEndTime: self.workEndTime ?? Date(),
            totalWorkTime: self.totalWorkTime ?? 0,
            wage: self.wage ?? 0,
            isRequestApprove: self.isRequestApprove,
            isManagerCheck: self.isManagerCheck
        )
    }
}
