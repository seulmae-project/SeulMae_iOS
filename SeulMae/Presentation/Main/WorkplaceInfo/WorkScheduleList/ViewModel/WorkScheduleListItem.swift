//
//  WorkScheduleListItem.swift
//  SeulMae
//
//  Created by 조기열 on 9/18/24.
//

import Foundation

struct WorkScheduleListItem: Hashable {
    enum ItemType {
        case workSchedule
    }
    
    let itemType: ItemType
    let workSchedule: WorkSchedule?
    
    init(workSchedule: WorkSchedule) {
        self.itemType = .workSchedule
        self.workSchedule = workSchedule
    }
}
