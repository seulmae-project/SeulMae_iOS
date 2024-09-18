//
//  WorkScheduleDetailsItem.swift
//  SeulMae
//
//  Created by 조기열 on 9/18/24.
//

import Foundation

struct WorkScheduleDetailsItem: Hashable {
    enum ItemType {
        case title, workTime, weekday, members
    }
    
    var itemType: ItemType
    var title: String
    var text: String?
    var weekdays: [Int]?
    var members: [Member]?
    
    init(title: String) {
        self.itemType = .title
        self.title = "이름"
        self.text = title
        self.weekdays = nil
        self.members = nil
    }
    
    init(time: String) {
        self.itemType = .workTime
        self.title = "근무 시간"
        self.text = time
        self.weekdays = nil
        self.members = nil
    }
    
    init(weekdays: [Int]) {
        self.itemType = .weekday
        self.title = "근무 요일"
        self.text = nil
        self.weekdays = weekdays
        self.members = nil
    }
    
    init(members: [Member]) {
        self.itemType = .members
        self.title = "근무지"
        self.text = nil
        self.weekdays = nil
        self.members = members
    }
}
