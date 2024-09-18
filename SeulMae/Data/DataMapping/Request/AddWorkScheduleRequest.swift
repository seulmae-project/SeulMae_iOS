//
//  AddWorkScheduleRequest.swift
//  SeulMae
//
//  Created by 조기열 on 9/18/24.
//

import Foundation

struct AddWorkScheduleRequest: ModelType {
    let workplaceId: Workplace.ID
    let workScheduleTitle: String
    let startTime: String // "09:00"
    let endTime: String // "13:00",
    let days: [Int] // [1, 2, 3, 4]
}
