//
//  WorkplaceDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation

struct WorkplaceDTO: ModelType {
    let id: Int
    let invitationCode: String?
    let name: String
    let contact: String?
    let imageURL: [String]?
    let thumbnailURL: [String]?
    let manager: String?
    let mainAddress: String?
    let subAddress: String?
    let userWorkplaceId: Int?
    let isManager: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "workplaceId"
        case invitationCode = "workplaceCode"
        case name = "workplaceName"
        case contact = "workplaceTel"
        case imageURL = "workplaceImageUrl"
        case thumbnailURL = "workplaceThumbnailUrl"
        case manager = "workplaceManagerName"
        case mainAddress
        case subAddress
        case userWorkplaceId
        case isManager
    }
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<[WorkplaceDTO]> {
    func toDomain() throws -> [Workplace] {
        guard let data else {
            throw MappingError.emptyData(Data.self)
        }
        
        return data.compactMap { try? $0.toDomain() }
    }
}

extension BaseResponseDTO<WorkplaceDTO> {
    func toDomain() throws -> Workplace {
        guard let data else {
            throw MappingError.emptyData(Data.self)
        }
        
        return try data.toDomain()
    }
}

extension WorkplaceDTO {
    func toDomain() throws -> Workplace {
        return .init(
            invitationCode: invitationCode ?? "",
            contact: contact ?? "",
            imageURL: imageURL ?? [],
            thumbnailURL: thumbnailURL ?? [],
            manager: manager ?? "",
            mainAddress: mainAddress ?? "",
            subAddress: subAddress ?? "",
            id: id,
            name: name,
            userWorkplaceId: userWorkplaceId ?? 0,
            isManager: isManager ?? false
        )
    }
}
