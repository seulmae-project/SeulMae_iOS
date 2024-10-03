//
//  ManagerHomeListItem.swift
//  SeulMae
//
//  Created by 조기열 on 10/3/24.
//

import Foundation

struct ManagerHomeListItem: Hashable {
    let attendanceRequestId: AttendanceRequest.ID
    let name: String
    let userImageUrl: String
    let isApprove: Bool
    let totalWorkTime: Double
    let workStartDate: Date
    let workEndDate: Date
    
    init(attendanceRequest: AttendanceRequest) {
        self.attendanceRequestId = attendanceRequest.id
        self.name = attendanceRequest.userName
        self.userImageUrl = attendanceRequest.userImageURL
        self.isApprove = attendanceRequest.isRequestApprove
        self.totalWorkTime = attendanceRequest.totalWorkTime
        self.workStartDate = attendanceRequest.workStartDate
        self.workEndDate = attendanceRequest.workEndDate
    }
}

