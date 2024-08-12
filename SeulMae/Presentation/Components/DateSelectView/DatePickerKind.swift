//
//  DatePickerKind.swift
//  SeulMae
//
//  Created by 조기열 on 8/11/24.
//

import Foundation

enum DatePickerKind: CustomStringConvertible {
    case year, month, day
    
    var description: String {
        switch self {
        case .year:
            return "년도"
        case .month:
            return "월"
        case .day:
            return "일"
        }
    }
}
