//
//  AddAnnounceRequset.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import Foundation

struct AddAnnounceRequset: ModelType {
    let workplaceId: Int
    let title: String
    let content: String
    let isImportant: Bool
}
