//
//  CalendarItem.swift
//  SeulMae
//
//  Created by 조기열 on 10/12/24.
//

import UIKit

struct CalendarItem: Hashable, Identifiable {
    enum ItemType {
        case weekday, day, empty
    }
    
    enum DayState: Hashable {
        case normal
        case highlight(color: UIColor, backgroundColor: UIColor)
        case none
    }
    
    let id: String
    let itemType: ItemType
    let weekday: String?
    let day: Int?
    let dayState: DayState?
    
    init(weekday: String) {
        self.id = UUID().uuidString
        self.itemType = .weekday
        self.weekday = weekday
        self.day = nil
        self.dayState = nil
    }
    
    init(day: Int, state: DayState) {
        self.id = UUID().uuidString
        self.itemType = .day
        self.day = day
        self.dayState = state
        self.weekday = nil
    }
}
