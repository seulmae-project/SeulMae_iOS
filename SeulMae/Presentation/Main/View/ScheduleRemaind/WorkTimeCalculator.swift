//
//  WorkTimeCalculator.swift
//  SeulMae
//
//  Created by 조기열 on 9/22/24.
//

import Foundation

final class WorkTimeCalculator {

//    "workplaceId": 12,
//     "workDate": "2024-09-21",
//     "workStartTime": "2024-09-21T10:09:07.328938",
//     "workEndTime": "2024-09-21T14:00:00",
//     "confirmedWage" : 55000,
//     "unconfirmedWage": 55000,
//     "totalWorkTime": 4, 이거 double 인지?
//     "deliveryMessage" : "string",
//     "day" : 6
    
    func calculate(start: Date, end: Date, wage: Int) -> AttendRequest {
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: start, to: end)
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        let day = components.day ?? 0
        Swift.print("근무 시간: \(hours)시간 \(minutes)분 \(seconds)초")
        Swift.print("요일: \(day)")
        let totalHours = (Double(hours) + (Double(minutes) / 60.0))
        let totalWage = (Double(wage) * totalHours)
        Swift.print("total wage: \(totalWage)")
        return AttendRequest(
            workDate: start,
            workStartTime: start,
            workEndTime: end,
            confirmedWage: totalWage,
            unconfirmedWage: totalWage,
            totalWorkTime: totalHours,
            deliveryMessage: "",
            day: day
        )
    }
}
