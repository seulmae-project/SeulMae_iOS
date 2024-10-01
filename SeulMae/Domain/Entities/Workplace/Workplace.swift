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
    let address: Address
    let invitationCode: String
    let contact: String
    let imageURLList: [String]
    let thumbnailURL: String?
    let manager: String?
    let mainAddress: String
    let subAddress: String?
}

