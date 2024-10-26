//
//  PlaceFinderSection.swift
//  SeulMae
//
//  Created by 조기열 on 10/26/24.
//

import Foundation

enum PlaceFinderSection: Int, CaseIterable, CustomStringConvertible {
    case reminder
    case card
    case workplace
    case application

    var title: String {
        switch self {
        case .workplace:
            return "내 근무지"
        case .application:
            return "가입 대기중인 근무지"
        default: 
            return ""
        }
    }

    var description: String {
        switch self {
        case .workplace: 
            return "승인이 되면 알림으로 알려드려요!"
        case .application: 
            return "승인이 되면 알림으로 알려드려요!"
        default: 
            return ""
        }
    }
}
