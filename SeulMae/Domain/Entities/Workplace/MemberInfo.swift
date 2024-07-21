//
//  MemberInfo.swift
//  SeulMae
//
//  Created by 조기열 on 7/20/24.
//

import Foundation

struct MemberInfo {
    struct WorkSchedule {
        let workScheduleIdentifier: Int
        let workScheduleTitle: String
        let days: [Int]
    }
    
    let name: String?
    let phoneNumber: String?
    let imageURL: String?
    let joinDate: Date? // 2024-07-19
    
    // let workSchedule: WorkSchedule
    let workScheduleIdentifier: Int?
    let workScheduleTitle: String?
    let days: [Int]?
    
    let payDay: Int?
    let baseWage: Int?
    let memo: String?
}
