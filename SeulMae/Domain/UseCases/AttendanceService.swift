//
//  WorkTimeCalculator.swift
//  SeulMae
//
//  Created by 조기열 on 9/22/24.
//

import Foundation
import RxSwift
import RxCocoa

final class AttendanceService {// : SharedSequenceConvertibleType {

//    typealias Element = WorkTimeRecordingItem
//    typealias SharingStrategy = DriverSharingStrategy
//    
//    func asSharedSequence() -> RxCocoa.SharedSequence<RxCocoa.DriverSharingStrategy, WorkTimeRecordingItem> {
//        return item
//    }

//    private var timer: Timer?
//    private var workSchedule: WorkSchedule?
//    private let item: SharedSequence<SharingStrategy, Element>
//    private let relay = PublishRelay<Element>()
//
//    private let workplaceRepository: WorkplaceRepository
//    static var wage: Int?
//    public init(
//        workplaceRepository: WorkplaceRepository
//    ) {
//        self.workplaceRepository = workplaceRepository
//        item = relay.asDriver()
//            .distinctUntilChanged()
//    }

    static func calculate(start: Date, end: Date, wage: Int) -> AttendRequest {
        let day = Calendar.current.component(.weekday, from: start)
        let diff = Calendar.current
            .dateComponents([.hour, .minute], from: start, to: end)
        let totalHours = Double(diff.hour ?? 0) + (Double(diff.minute ?? 0) / 60)
        return AttendRequest(
            workDate: start,
            workStartTime: start,
            workEndTime: end,
            confirmedWage: Double(wage) * totalHours,
            unconfirmedWage: Double(wage) * totalHours,
            totalWorkTime: totalHours,
            deliveryMessage: "",
            day: (day - 1)
        )
    }

    static func end(wage: Int) -> (Bool, AttendRequest?) {
        let userDefaults = UserDefaults.standard
        if let saved = userDefaults.object(forKey: "onAttendance") as? Date,
           let day = Calendar.current.dateComponents([.day], from: saved).day {
            let endDate = Date.ext.now
            let diff = Calendar.current
                .dateComponents([.hour, .minute], from: saved, to: endDate)
            let totalHours = Double(diff.hour ?? 0) + (Double(diff.minute ?? 0) / 60)
            let request = AttendRequest(
                workDate: saved,
                workStartTime: saved,
                workEndTime: endDate,
                confirmedWage: 0,// totalHours * Double(wage),
                unconfirmedWage: totalHours * Double(wage),
                totalWorkTime: totalHours,
                deliveryMessage: "",
                day: day)
            return (true, request)
        } else {
            return (false, nil)
        }
    }

//    func start(workSchedule: WorkSchedule) {
//        self.workSchedule = workSchedule
//        timer = Timer.scheduledTimer(
//            withTimeInterval: 1.0, repeats: true) { _ in
//                let element = Element(
//                    leftTime: self.getLeftTime() ?? "",
//                    totalMonthlySalary: "",
//                    amountEarnedToday: "",
//                    process: self.getRecordingState() ?? 0
//                )
//                self.relay.accept(element)
//        }
//    }
    
//    private func getLeftTime() -> String? {
//        let components = getLeftTimeComponents()
//        guard let hours = components?.hour,
//              let minutes = components?.minute else {
//            return nil
//        }
//        
//        return "\(hours)시간 \(minutes)분 남았어요!"
//        // 아직 근무 시간이 되지 않았어요?
//    }
//    
//    private func getLeftTimeComponents() -> DateComponents? {
//        guard let workSchedule else {
//            return nil
//        }
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm:ss"
//        dateFormatter.timeZone = TimeZone.current
//        
//        guard let endDate = dateFormatter.date(from: workSchedule.endTime) else {
//            return nil
//        }
//
//        var calendar = Calendar.current
//        calendar.timeZone = TimeZone.current
//        return calendar.dateComponents([.hour, .minute], from: Date(), to: endDate)
//    }
    
//    private func getRecordingState() -> Double? {
//        guard let workSchedule else {
//            return nil
//        }
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm:ss"
//        dateFormatter.timeZone = TimeZone.current
//        
//        guard let startDate  = dateFormatter.date(from: workSchedule.endTime),
//              let endDate = dateFormatter.date(from: workSchedule.endTime) else {
//            return nil
//        }
//        
//        let totalDuration = endDate.timeIntervalSince(startDate)
//        let elapsedDuration = Date().timeIntervalSince(startDate)
//        let completionPercentage = (totalDuration > 0) ? (elapsedDuration / totalDuration) * 100 : 0
//        
//        return completionPercentage
//    }
}
