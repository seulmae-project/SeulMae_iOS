//
//  WorkSchedule.swift
//  SeulMae
//
//  Created by 조기열 on 7/20/24.
//

import Foundation

struct WorkSchedule: Identifiable, Hashable {
    let id: Int
    let title: String
    let days: [Int]
    let startTime: String
    let endTime: String
    let isActive: Bool
}
