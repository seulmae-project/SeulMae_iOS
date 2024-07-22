//
//  Member.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import Foundation

struct Member: Identifiable, Hashable {
    var id: Int
    var name: String
    var imageURL: String
    var isManager: Bool
}
