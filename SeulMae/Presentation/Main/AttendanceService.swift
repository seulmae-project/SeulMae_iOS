//
//  WorkTimeCalculator.swift
//  SeulMae
//
//  Created by 조기열 on 9/22/24.
//

import Foundation
import RxSwift
import RxCocoa

final class AttendanceService: SharedSequenceConvertibleType {

    typealias Element = WorkTimeRecordingItem
    typealias SharingStrategy = DriverSharingStrategy
    
    func asSharedSequence() -> RxCocoa.SharedSequence<RxCocoa.DriverSharingStrategy, WorkTimeRecordingItem> {
        return item
    }

    private var timer: Timer?
    private var workSchedule: WorkSchedule?
    private let item: SharedSequence<SharingStrategy, Element>
    private let relay = PublishRelay<Element>()
    
    public init() {
        item = relay.asDriver()
            .distinctUntilChanged()
    }

    static func start() -> Bool {
        let userDefaults = UserDefaults.standard
        if let saved = userDefaults.object(forKey: "onAttendance") as? Date {
            return false
        } else {
            let now = Date.ext.now
            userDefaults.set(now, forKey: "onAttendance")
            return true
        }
    }

//        "workplaceId": 1,
//            "workDate": "2024-07-01",
//            "workStartTime": "2024-07-01T14:26:07.328938",
//            "workEndTime": "2024-07-01T20:00:00",
//            "unconfirmedWage": 55000,
//            "totalWorkTime": 5.5
    func start(workSchedule: WorkSchedule) {
        self.workSchedule = workSchedule
        timer = Timer.scheduledTimer(
            withTimeInterval: 1.0, repeats: true) { _ in
                let element = Element(
                    leftTime: self.getLeftTime() ?? "",
                    totalMonthlySalary: "",
                    amountEarnedToday: "",
                    process: self.getRecordingState() ?? 0
                )
                self.relay.accept(element)
        }
    }
    
    private func getLeftTime() -> String? {
        let components = getLeftTimeComponents()
        guard let hours = components?.hour,
              let minutes = components?.minute else {
            return nil
        }
        
        return "\(hours)시간 \(minutes)분 남았어요!"
        // 아직 근무 시간이 되지 않았어요?
    }
    
    private func getLeftTimeComponents() -> DateComponents? {
        guard let workSchedule else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        
        guard let endDate = dateFormatter.date(from: workSchedule.endTime) else {
            return nil
        }

        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        return calendar.dateComponents([.hour, .minute], from: Date(), to: endDate)
    }
    
    private func getRecordingState() -> Double? {
        guard let workSchedule else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        
        guard let startDate  = dateFormatter.date(from: workSchedule.endTime),
              let endDate = dateFormatter.date(from: workSchedule.endTime) else {
            return nil
        }
        
        let totalDuration = endDate.timeIntervalSince(startDate)
        let elapsedDuration = Date().timeIntervalSince(startDate)
        let completionPercentage = (totalDuration > 0) ? (elapsedDuration / totalDuration) * 100 : 0
        
        return completionPercentage
    }
    
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
