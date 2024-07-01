//
//  Int+CalendarView.swift
//  SeulMae
//
//  Created by 조기열 on 7/1/24.
//

import Foundation

extension Int: Extended {}
extension Extension where ExtendedType == Int {
    
    var isLeapYear: Bool {
        assert(type > 0, "Year must be greater than 0")
        return (type != 0) &&
        (type % 4 == 0) &&
        ((type % 400 == 0) || (type % 100 != 0))
    }
}
