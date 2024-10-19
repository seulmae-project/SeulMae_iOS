//
//  Workplace.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation

struct Workplace: Identifiable, Hashable {
    let id: Int
    let name: String
    let userWorkplaceId: Int?
    let isManager: Bool?
    let invitationCode: String
    let contact: String
    let imageURLList: [String]
    let thumbnailURL: String?
    let manager: String?
    let mainAddress: String
    let subAddress: String?
    let address: Address?

    init(id: Int, name: String, userWorkplaceId: Int?, isManager: Bool?, invitationCode: String, contact: String, imageURLList: [String], thumbnailURL: String?, manager: String?, mainAddress: String, subAddress: String?, address: Address?) {
        self.id = id
        self.name = name
        self.userWorkplaceId = userWorkplaceId
        self.isManager = isManager
        self.invitationCode = invitationCode
        self.contact = contact
        self.imageURLList = imageURLList
        self.thumbnailURL = thumbnailURL
        self.manager = manager
        self.mainAddress = mainAddress
        self.subAddress = subAddress
        self.address = address
    }
    
    init(entity: WorkplaceModel) {
        self.id = Int(entity.id)
        self.name = entity.name ?? ""
        self.userWorkplaceId = 0
        self.isManager = entity.isManager
        self.invitationCode = entity.invitationCode ?? ""
        self.contact = entity.contact ?? ""
        self.imageURLList = []
        self.thumbnailURL = entity.thumbnailURL
        self.manager = entity.manager
        self.mainAddress = entity.mainAddress ?? ""
        self.subAddress = entity.subAddress
        self.address = nil
    }
}

