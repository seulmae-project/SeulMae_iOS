//
//  AnnounceItem.swift
//  SeulMae
//
//  Created by 조기열 on 8/31/24.
//

import Foundation

struct AnnounceListItem: Hashable {
    var announceType: String
    var title: String
    var createdDate: Date
    var announce: Announce
    
    init(announce: Announce) {
        self.announceType = ""
        self.title = ""
        self.createdDate = Date()
        self.announce = announce
    }
}
