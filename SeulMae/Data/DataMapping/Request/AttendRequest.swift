//
//  AttendRequest.swift
//  SeulMae
//
//  Created by 조기열 on 9/18/24.
//

import Foundation

struct AttendRequest: ModelType {
    var workplaceId: Workplace.ID?
    let workDate: Date
    let workStartTime: Date
    let workEndTime: Date
    let confirmedWage: Double?
    let unconfirmedWage: Double
    let totalWorkTime: Double
    let deliveryMessage: String
    let day: Int?
    
//    {
//        "workplaceId": 1,
//        "workDate": "2024-07-02",
//        "workStartTime": "2024-07-02T14:26:07.328938",
//        "workEndTime": "2024-07-02T21:00:00",
//        "unconfirmedWage": 55000,
//        "totalWorkTime": 5.5,
//        "deliveryMessage" : "string"
//    }
//    {
//        "workplaceId": 12,
//        "workDate": "2024-09-21",
//        "workStartTime": "2024-09-21T10:09:07.328938",
//        "workEndTime": "2024-09-21T14:00:00",
//        "confirmedWage" : 55000,
//        "unconfirmedWage": 55000,
//        "totalWorkTime": 4,
//        "deliveryMessage" : "string",
//        "day" : 6
//    }
}
