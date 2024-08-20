//
//  Workplace.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation

struct Workplace: Identifiable {
    let invitationCode: String
    let contact: String
    let imageURL: [String]
    let thumbnailURL: [String]
    let manager: String
    let mainAddress: String
    let subAddress: String
    
    // signin
    let id: Int
    let name: String
    let userWorkplaceId: Int
    let isManager: Bool
}
