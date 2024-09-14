//
//  AnnounceDetail.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import Foundation

struct AnnounceDetail {
    let id: Announce.ID
    let workplaceId: Int
    let title: String
    let content: String
    let regDate: Date
    let revisionDate: Date
    let views: Int
    let isImportant: Bool
}
