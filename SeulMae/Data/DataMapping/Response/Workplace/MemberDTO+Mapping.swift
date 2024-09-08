//
//  MemberDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import Foundation

struct MemberDTO: ModelType {
    let id: Int
    let name: String?
    let imageURL: String?
    let isManager: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "userId"
        case name = "userName"
        case imageURL = "userImageUrl"
        case isManager = "manager"
    }
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<[MemberDTO]> {
    func toDomain() -> [Member] {
        return data?.map { $0.toDomain() } ?? []
    }
}

extension MemberDTO {
    func toDomain() -> Member {
        return .init(
            id: id,
            name: name ?? "",
            imageURL: imageURL ?? "",
            isManager: isManager ?? false
        )
    }
}
