//
//  WorkScheduleDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 7/20/24.
//

import Foundation

struct WorkScheduleDTO: ModelType {
    let id: String
    let title: String?
    let days: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case id = "workScheduleId"
        case title = "workScheduleTitle"
        case days
    }
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<WorkScheduleDTO> {
    func toDomain() -> WorkSchedule? {
        return data?.toDomain()
    }
}

extension WorkScheduleDTO {
    func toDomain() -> WorkSchedule {
        return .init(
            id: id,
            title: title ?? "",
            days: days ?? []
        )
    }
}
