//
//  String+CalendarView.swift
//  SeulMae
//
//  Created by 조기열 on 7/1/24.
//

import Foundation

extension String: Extended {}
extension Extension where ExtendedType == String {
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var asDate: Date? {
        return ExtendedType.ext
            .dateFormatter
            .date(from: type)
    }
}
