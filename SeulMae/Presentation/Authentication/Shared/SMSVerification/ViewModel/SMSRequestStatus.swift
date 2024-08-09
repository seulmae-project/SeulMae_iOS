//
//  SMSRequestStatus.swift
//  SeulMae
//
//  Created by 조기열 on 8/7/24.
//

import Foundation

enum SMSRequestStatus {
    case pending
    case request
    case reRequest
    
    var isSending: Bool {
        [.request, .reRequest].contains(self)
    }
}
