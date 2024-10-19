//
//  SubmittedApplication.swift
//  SeulMae
//
//  Created by 조기열 on 10/19/24.
//

import Foundation

struct SubmittedApplication: Hashable {
    let isApprove: Bool
    let workplaceName: String
    let workplaceId: Int
    let decisionDate: Date
    let submmitAt: Date
}
