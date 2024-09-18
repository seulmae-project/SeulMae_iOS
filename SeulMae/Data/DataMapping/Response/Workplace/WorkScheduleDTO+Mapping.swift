//
//  WorkScheduleDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 7/20/24.
//

import Foundation

struct WorkScheduleDTO: ModelType {
    let id: Int
    let title: String?
    let days: [Int]?
    let startTime: String?
    let endTime: String?
    let isActive: Bool?
 
    enum CodingKeys: String, CodingKey {
        case id = "workScheduleId"
        case title = "workScheduleTitle"
        case days
        case startTime
        case endTime
        case isActive
    }
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<[WorkScheduleDTO]>{
    func toDomain() -> [WorkSchedule] {
        return data?.map { $0.toDomain() } ?? []
    }
}

extension BaseResponseDTO<WorkScheduleDTO>{
    func toDomain() -> WorkSchedule? {
        return data?.toDomain()
    }
}

extension WorkScheduleDTO {
    func toDomain() -> WorkSchedule {
        return .init(
            id: self.id,
            title: self.title ?? "",
            days: self.days ?? [],
            startTime: self.startTime ?? "",
            endTime: self.endTime ?? "",
            isActive: self.isActive ?? false
        )
    }
}
