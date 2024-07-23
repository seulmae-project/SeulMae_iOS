//
//  NoticeDetailItem.swift
//  SeulMae
//
//  Created by 조기열 on 7/23/24.
//

import Foundation

struct NoticeDetailItem {
    enum ItemKind {
        case normal
        case mustRead
    }
    
    let kind: ItemKind
    let title: String
    let content: String
    
    init(_ noticeDetail: NoticeDetail) {
        self.kind = .normal
        // TODO: dto 수정되면 kind에 대한 로직 추가
        self.title = noticeDetail.title
        self.content = noticeDetail.content
    }
}

