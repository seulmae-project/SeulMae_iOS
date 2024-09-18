//
//  WorkScheduleListItem.swift
//  SeulMae
//
//  Created by 조기열 on 9/18/24.
//

import Foundation

struct WorkScheduleListItem {
    enum ItemType {
        case workSchedule
    }
    
    let itmeType: ItemType
    let workSchedule: WorkSchedule?
    
    init(workSchedule: WorkSchedule) {
        self.itmeType = .workSchedule
        self.workSchedule = workSchedule
    }
}
