//
//  SMSRequestStatus.swift
//  SeulMae
//
//  Created by 조기열 on 8/7/24.
//

import Foundation

enum SMSRequestStatus {
    case request
    case reRequest
    case invalid
    
    var isSending: Bool {
        [.request, .reRequest].contains(self)
    }
}
