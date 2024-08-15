//
//  Date+CalendarView.swift
//  SeulMae
//
//  Created by 조기열 on 7/1/24.
//

import Foundation

extension Date: Extended {}
extension Extension where ExtendedType == Date {

    static var now: Date {
        Date()
    }
    
    var weekday: Int {
        Calendar.current.component(.weekday, from: type)
    }
    
    var firstDayOfMonth: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: type))!
    }
    
    var firstWeekDay: Int {
        return ExtendedType.ext.now
            .ext.firstDayOfMonth
            .ext.weekday
    }
}
