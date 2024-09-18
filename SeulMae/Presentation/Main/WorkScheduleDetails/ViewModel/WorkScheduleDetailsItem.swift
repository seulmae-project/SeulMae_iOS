//
//  WorkScheduleDetailsItem.swift
//  SeulMae
//
//  Created by 조기열 on 9/18/24.
//

import Foundation

struct WorkScheduleDetailsItem: Hashable {
    enum ItemType {
        case name, startTime, endTime, weekday, members
    }
    
    var itemType: ItemType
    var name: String?
    var time: String?
    var weekdays: [Int]?
    var members: [Member]?
    
    var title: String {
        switch self.itemType {
        case .name: return "이름"
        case .startTime: return "시작 시간"
        case .endTime: return "종료 시간"
        case .weekday: return "근무 요일"
        case .members: return "근무자"
        }
    }
    
    var date: Date? {
        guard [.startTime, .endTime].contains(self.itemType),
              let timeString = time else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.date(from: timeString)
    }
    
    init(name: String) {
        self.itemType = .name
        self.name = name
    }
    
    init(startTime: String) {
        self.itemType = .startTime
        self.time = startTime
    }
    
    init(endTime: String) {
        self.itemType = .endTime
        self.time = endTime
    }
    
    init(weekdays: [Int]) {
        self.itemType = .weekday
        self.weekdays = weekdays
    }
    
    init(members: [Member]) {
        self.itemType = .members
        self.members = members
    }
}
