//
//  ApplicationDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 10/19/24.
//

import Foundation

struct ApplicationDTO: ModelType {
    let isApprove: Bool
    let workplaceName: String
    let workplaceId: Int
    let decisionDate: Date
    let submmitAt: Date

    enum CodingKeys: String, CodingKey {
        case isApprove
        case workplaceName
        case workplaceId
        case decisionDate
        case submmitAt = "regDateWorkplaceJoinHistory"
    }
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<[ApplicationDTO]> {
    func toDomain() -> [SubmittedApplication] {
        return data?.map { $0.toDomain() } ?? []
    }
}

extension ApplicationDTO {
    func toDomain() -> SubmittedApplication {
        return .init(
            isApprove: self.isApprove,
            workplaceName: self.workplaceName,
            workplaceId: self.workplaceId,
            decisionDate: self.decisionDate,
            submmitAt: self.submmitAt
        )
    }
}
