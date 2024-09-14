//
//  Announce.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import Foundation

struct Announce: Identifiable, Hashable {
    let id: Int // announcementId
    let title: String
    let content: String?
    let regDate: String?
    let views: Int?
}

