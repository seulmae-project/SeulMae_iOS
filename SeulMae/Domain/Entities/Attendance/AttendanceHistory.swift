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
