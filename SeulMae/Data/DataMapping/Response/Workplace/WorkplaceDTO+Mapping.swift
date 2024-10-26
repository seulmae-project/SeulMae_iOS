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
    let imageURLList: [String]?
    let thumbnailURL: String?
    let manager: String?
    let mainAddress: String?
    let subAddress: String?
    let address: AddressDTO?
    let userWorkplaceId: Int?
    let isManager: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "workplaceId"
        case invitationCode = "workplaceCode"
        case name = "workplaceName"
        case contact = "workplaceTel"
        case imageURLList = "workplaceImageUrlList"
        case thumbnailURL = "workplaceThumbnailUrl"
        case manager = "managerName"
        case mainAddress
        case subAddress
        case address
        case userWorkplaceId
        case isManager = "isManger"
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
            invitationCode: self.invitationCode ?? "",
            contact: self.contact ?? "",
            imageURLList: self.imageURLList ?? [],
            thumbnailURL: self.thumbnailURL,
            manager: self.manager ?? "",
            mainAddress: self.mainAddress ?? "",
            subAddress: self.subAddress ?? "",
            address: self.address?.toDomain() 
        )
    }
}
