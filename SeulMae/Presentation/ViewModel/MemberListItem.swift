//
//  MemberListItem.swift
//  SeulMae
//
//  Created by 조기열 on 8/16/24.
//

import Foundation

enum MemberListSection: Hashable {
    case row
}

struct MemberListItem: Hashable {
    var member: Member
    var isManager: Bool
    var imageURL: String
    
    init(member: Member) {
        self.member = member
        self.isManager = member.isManager
        self.imageURL = member.imageURL
    }
}
