//
//  Workplace.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation

struct Workplace: Identifiable {
    let id: Int
    let workplaceCode: String
    let workplaceName: String
    let workplaceTel: String
    let workplaceImageUrl: [String]
    let workplaceManagerName: String
    let subAddress: String
    let mainAddress: String
}
