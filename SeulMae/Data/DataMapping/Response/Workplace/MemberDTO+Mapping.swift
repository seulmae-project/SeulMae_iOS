//
//  MemberDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import Foundation

struct MemberDTO: ModelType {
    let id: Int?
    let name: String?
    let imageURL: String?
    let isManager: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "userId"
        case name = "userName"
        case imageURL = "userImageURL"
        case isManager
    }
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<[MemberDTO]> {
    func toDomain() throws -> [Member] {
        guard let data else {
            throw MappingError.emptyData(Data.self)
        }
        
        return data.compactMap { try? $0.toDomain() }
    }
}

extension MemberDTO {
    func toDomain() throws -> Member {
        guard let id else {
            throw MappingError.invalidData(Self.self)
        }
        
        return .init(
            id: id,
            name: name ?? "",
            imageURL: imageURL ?? "",
            isManager: isManager ?? false
        )
    }
}
