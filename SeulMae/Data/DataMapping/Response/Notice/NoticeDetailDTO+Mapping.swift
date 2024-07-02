//
//  NoticeDetailDTO.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import Foundation

struct NoticeDetailDTO: ModelType {
    let workplaceID: Int?
    let title: String?
    let content: String?
    let regDate: Date?
    let revisionDate: Date?
    let views: Int?
    
    enum CodingKeys: String, CodingKey {
        case workplaceID = "workplaceId"
        case title
        case content
        case regDate
        case revisionDate
        case views
    }
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<NoticeDetailDTO> {
    func toDomain() throws -> NoticeDetail {
        if let reason {
            throw APIError.unauthorized(reason)
        }
        
        guard let data else {
            throw MappingError.emptyData(Data.self)
        }
        
        return try data.toDomain()
    }
}

extension NoticeDetailDTO {
    func toDomain() throws -> NoticeDetail {
        guard let workplaceID else { 
            throw MappingError.invalidData(Self.self)
        }
        
        return .init(
            workplaceId: workplaceID,
            title: title ?? "",
            content: content ?? "",
            regDate: regDate ?? Date(),
            revisionDate: revisionDate ?? Date(),
            views: views ?? 0
        )
    }
}
