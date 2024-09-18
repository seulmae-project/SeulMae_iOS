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
    let address: AddressDTO?
    
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
        case address
    }
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<[WorkplaceDTO]> {
    func toDomain() -> [Workplace] {
        return data?.map { $0.toDomain() } ?? []
    }
}

extension BaseResponseDTO<WorkplaceDTO> {
    func toDomain() -> Workplace {
        return data!.toDomain()
    }
}

extension WorkplaceDTO {
    func toDomain() -> Workplace {
        return .init(
            id: self.id,
            name: self.name,
            userWorkplaceId: self.userWorkplaceId,
            isManager: self.isManager ?? false,
            address: self.address?.toDomain() ?? .init(mainAddress: "", subAddress: ""),
            invitationCode: self.invitationCode ?? "",
            contact: self.contact ?? "",
            imageURL: self.imageURL ?? [],
            thumbnailURL: self.thumbnailURL ?? [],
            manager: self.manager ?? "",
            mainAddress: self.mainAddress ?? "",
            subAddress: self.subAddress ?? ""
        )
    }
}
