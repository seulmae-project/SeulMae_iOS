//
//  NoticeDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import Foundation

struct NoticeDTO: ModelType {
    let id: Int
    let title: String?
    let content: String?
    let regDate: String?
    let views: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "announcementId"
        case title
        case content
        case regDate
        case views
    }
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<[NoticeDTO]> {
    func toDomain() throws -> [Announce] {
        return data?.map { $0.toDomain() } ?? []
    }
}

extension NoticeDTO {
    func toDomain() -> Announce {
        return .init(
            id: id,
            title: title ?? "",
            content: content,
            regDate: regDate,
            views: views
        )
    }
}


