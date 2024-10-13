//
//  WorkplaceState.swift
//  SeulMae
//
//  Created by 조기열 on 10/14/24.
//

import Foundation

struct WorkplaceState {
    enum MessageType {
        case ok
    }

    let name: String
    let workStartTime: String // "09:00:00"
    let message: String
    let messageType: MessageType
    let userState: UserState

}
