//
//  WorkplaceDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation

struct WorkplaceDTO: ModelType {
    let id: Int
    let invitationCode: String
    let name: String
    let contact: String?
    let imageURL: [String]?
    let thumbnailURL: [String]?
    let manager: String?
    let mainAddress: String?
    let subAddress: String?
    
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
            id: id,
            invitationCode: invitationCode,
            name: name,
            contact: contact ?? "",
            imageURL: imageURL ?? [],
            thumbnailURL: thumbnailURL ?? [],
            manager: manager ?? "",
            mainAddress: mainAddress ?? "",
            subAddress: subAddress ?? ""
        )
    }
}
