//
//  AnnounceDetailDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import Foundation

struct AnnounceDetailDTO: ModelType {
    let id: Int
    let workplaceId: Int
    let title: String?
    let content: String?
    let regDate: Date?
    let revisionDate: Date?
    let views: Int?
    let isImportant: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "announcementId"
        case workplaceId
        case title
        case content
        case regDate
        case revisionDate
        case views
        case isImportant
    }
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<AnnounceDetailDTO> {
    func toDomain() throws -> AnnounceDetail {
        return data!.toDomain() 
    }
}

extension AnnounceDetailDTO {
    func toDomain() -> AnnounceDetail {
        return .init(
            id: self.id,
            workplaceId: self.workplaceId,
            title: self.title ?? "",
            content: self.content ?? "",
            regDate: self.regDate ?? Date(),
            revisionDate: self.revisionDate ?? Date(),
            views: self.views ?? 0,
            isImportant: isImportant ?? false
        )
    }
}
