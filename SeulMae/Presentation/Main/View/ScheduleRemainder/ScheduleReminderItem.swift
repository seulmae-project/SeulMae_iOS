//
//  ScheduleReminderItem.swift
//  SeulMae
//
//  Created by 조기열 on 9/24/24.
//

import Foundation

struct ScheduleReminderItem {
    enum ItemType {
        case reminder, workScheduleList
    }
    
    let itemType: ItemType
    let reminder: String
    let workSchedules: [WorkSchedule]
    
    init(reminder: String) {
        self.itemType = .reminder
        self.reminder = reminder
        self.workSchedules = []
    }
    
    init(workSchedules: [WorkSchedule]) {
        self.itemType = .workScheduleList
        self.reminder = ""
        self.workSchedules = workSchedules
    }
}
