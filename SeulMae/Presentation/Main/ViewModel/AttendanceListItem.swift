//
//  AttendanceListItem.swift
//  SeulMae
//
//  Created by 조기열 on 8/16/24.
//

import Foundation

enum AttendanceListSection: Hashable {
    case list
}

struct AttendanceListItem: Hashable, Identifiable {
    let id: Int
    let imageURL: String
    let name: String
    let isApprove: Bool
    let totalWorkTime: Double
    let workStartDate: Date
    let workEndDate: Date
    
    init(request: AttendanceRequest) {
        self.id = request.id
        self.imageURL = request.userImageURL
        self.name = request.userName
        self.isApprove = request.isRequestApprove
        self.totalWorkTime = request.totalWorkTime
        self.workStartDate = request.workStartDate
        self.workEndDate = request.workEndDate
    }
}
