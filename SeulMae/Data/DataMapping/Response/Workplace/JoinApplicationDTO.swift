//
//  JoinApplicationDTO.swift
//  SeulMae
//
//  Created by 조기열 on 11/13/24.
//

import Foundation

struct JoinApplicationDTO: ModelType {
    let id: JoinApplication.ID
    let username: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "workplaceApproveId"
        case username = "userName"
        case createdAt = "requestDate"
    }
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<[JoinApplicationDTO]> {
    func toDomain() -> [JoinApplication] {
        return data?.map { $0.toDomain() } ?? []
    }
}

extension JoinApplicationDTO {
    func toDomain() -> JoinApplication {
        return .init(
            id: self.id,
            username: self.username,
            createdAt: self.createdAt
        )
    }
}

