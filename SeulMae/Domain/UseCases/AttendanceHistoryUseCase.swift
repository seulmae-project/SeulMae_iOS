//
//  AttendanceHistoryUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 9/19/24.
//

import Foundation
import RxSwift

protocol AttendanceHistoryUseCase {
    func fetchAttendanceCalendar(date: Date) -> Single<[AttendanceHistory]>
    func fetchWorkInfo() -> Single<WorkInfo>
    func fetchMonthlyAttendanceSummery(year: Int, month: Int) -> Single<MonthlyAttenanceSummary>
    func fetchAttendanceHistories(year: Int, month: Int, page: Int, size: Int) -> Single<[AttendanceHistory]>
    func fetchAttendanceHistoryDetails(attendanceHistoryId: AttendanceHistory.ID) -> Single<AttendanceHistory>
    func updateAttendanceHistory(attendanceHistoryId: AttendanceHistory.ID) -> Single<Bool>
}

final class DefaultAttendanceHistoryUseCase: AttendanceHistoryUseCase {
    
    private var attendanceHistoryRepository: AttendanceHistoryRepository 
    private let userRepository = UserRepository(network: UserNetworking())

    init(attendanceHistoryRepository: AttendanceHistoryRepository) {
        self.attendanceHistoryRepository = attendanceHistoryRepository
    }
    
    func fetchAttendanceCalendar(date: Date) -> RxSwift.Single<[AttendanceHistory]> {
        let workplaceId = userRepository.currentWorkplaceId
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        return attendanceHistoryRepository.fetchAttendanceCalendar(workplaceId: workplaceId, year: year, month: month)
    }

    func fetchWorkInfo() -> RxSwift.Single<WorkInfo> {
        var currentWorkplaceId = userRepository.currentWorkplaceId
        return attendanceHistoryRepository.fetchWorkInfo(workplaceId: currentWorkplaceId)
    }
    
    func fetchMonthlyAttendanceSummery(year: Int, month: Int) -> RxSwift.Single<MonthlyAttenanceSummary> {
        var currentWorkplaceId = userRepository.currentWorkplaceId
        return attendanceHistoryRepository.fetchMonthlyAttendanceSummery(workplaceId: currentWorkplaceId, year: year, month: month)
    }
    
    func fetchAttendanceHistories(year: Int, month: Int, page: Int, size: Int) -> RxSwift.Single<[AttendanceHistory]> {
        var currentWorkplaceId = userRepository.currentWorkplaceId
        return attendanceHistoryRepository.fetchAttendanceHistories(workplaceId: currentWorkplaceId, year: year, month: month, page: page, size: size)
    }
    
    func fetchAttendanceHistoryDetails(attendanceHistoryId: AttendanceHistory.ID) -> RxSwift.Single<AttendanceHistory> {
        return attendanceHistoryRepository.fetchAttendanceHistoryDetails(attendanceHistoryId: attendanceHistoryId)
    }
    
    func updateAttendanceHistory(attendanceHistoryId: AttendanceHistory.ID) -> RxSwift.Single<Bool> {
        return attendanceHistoryRepository.updateAttendanceHistory(attendanceHistoryId: attendanceHistoryId)
    }
}
