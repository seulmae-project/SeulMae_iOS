//
//  WorkSchedule.swift
//  SeulMae
//
//  Created by 조기열 on 7/20/24.
//

import Foundation

struct WorkSchedule: Identifiable, Hashable, Encodable {
    let id: Int
    let title: String
    let days: [Int]
    let startTime: String // "09:00:00"
    let endTime: String // "13:00:00"
    let isActive: Bool
}
