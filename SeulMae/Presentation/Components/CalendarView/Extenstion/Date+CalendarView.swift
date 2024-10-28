//
//  Date+CalendarView.swift
//  SeulMae
//
//  Created by 조기열 on 7/1/24.
//

import Foundation

extension Date: Extended {}
extension Ext where ExtendedType == Date {

    static var now: Date { Date() }
    
    var weekday: Int {
        Calendar.current.component(.weekday, from: type)
    }
    
    var firstDayOfMonth: Date {
        let calendar = Calendar.current
        let componets = calendar.dateComponents([.year, .month], from: type)
        return calendar.date(from: componets) ?? Ext.now
    }
    
    var month: Int {
        Calendar.current.component(.month, from: firstDayOfMonth)
    }
    
    var days: Int {
        return Calendar.current
            .range(of: .day, in: .month, for: firstDayOfMonth)?
            .count ?? 0
    }
    
    var firstWeekDay: Int {
        return firstDayOfMonth
            .ext.weekday
    }

    var short: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: type)
    }
}
