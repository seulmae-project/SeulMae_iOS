//
//  Workplace.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation

struct Workplace: Identifiable {
    let id: Int
    let invitationCode: String
    let name: String
    let contact: String
    let imageURL: String
    let thumbnailURL: String
    let manager: String
    let mainAddress: String
    let subAddress: String
}
