//
//  AnnounceDetailItem.swift
//  SeulMae
//
//  Created by 조기열 on 7/23/24.
//

import Foundation

struct AnnounceDetailItem: Identifiable {
    let id: Announce.ID
    let title: String
    let content: String
    let isImportant: Bool
    let announceDetail: AnnounceDetail
    
    init(_ announceDetail: AnnounceDetail) {
        self.id = announceDetail.id
        self.title = announceDetail.title
        self.content = announceDetail.content
        self.isImportant = announceDetail.isImportant
        self.announceDetail = announceDetail
    }
}

