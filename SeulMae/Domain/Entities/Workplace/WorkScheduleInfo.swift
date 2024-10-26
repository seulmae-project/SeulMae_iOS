//
//  WorkScheduleInfo.swift
//  SeulMae
//
//  Created by 조기열 on 9/18/24.
//

import Foundation

struct WorkScheduleInfo: ModelType {
    let title: String
    let start: String
    let end: String
    let weekdays: [Int]
}
