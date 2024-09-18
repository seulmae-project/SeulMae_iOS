//
//  DefaultAttedanceHistoryRepository.swift
//  SeulMae
//
//  Created by 조기열 on 9/16/24.
//

import Foundation
import RxSwift

protocol AttedanceHistoryRepository {
    func fetchWorkInfo(workplaceId: Workplace.ID) -> Single<WorkInfo>
    func fetchMonthlyAttendanceSummery(workplaceId: Workplace.ID, year: Int, month: Int) -> Single<MonthlyAttenanceSummary>
    func fetchAttendanceHistories(workplaceId: Workplace.ID, year: Int, month: Int, page: Int, size: Int) -> Single<[AttendanceHistory]>
    func fetchAttendanceHistoryDetails(attendanceHistoryId: AttendanceHistory.ID) -> Single<AttendanceHistory>
    func updateAttendanceHistory(attendanceHistoryId: AttendanceHistory.ID) -> Single<Bool>
}

class DefaultAttedanceHistoryRepository: AttedanceHistoryRepository {
    
    // MARK: - Dependancies
    
    private let network: AttendanceHistoryNetworking
    
    // MARK: - Life Cycle Methods
    
    init(network: AttendanceHistoryNetworking) {
        self.network = network
    }
    
    func fetchWorkInfo(workplaceId: Workplace.ID) -> RxSwift.Single<WorkInfo> {
        return network.rx
            .request(.fetchWorkeInfo(workplaceId: workplaceId))
            .map(BaseResponseDTO<WorkeInfoDTO>.self)
            .map { $0.toDomain()! }
    }
    
    func fetchMonthlyAttendanceSummery(workplaceId: Workplace.ID, year: Int, month: Int) -> RxSwift.Single<MonthlyAttenanceSummary> {
        return network.rx
            .request(.fetchMonthlyAttendanceSummery(workplaceId: workplaceId, year: year, month: month))
            .map(BaseResponseDTO<MonthlyAttenanceSummaryDTO>.self)
            .map { $0.toDomain()! }
    }
    
    func fetchAttendanceHistories(workplaceId: Workplace.ID, year: Int, month: Int, page: Int, size: Int) -> RxSwift.Single<[AttendanceHistory]> {
        return network.rx
            .request(.fetchAttendanceHistories(workplaceId: workplaceId, year: year, month: month, page: page, size: size))
            .map(BaseResponseDTO<[AttendanceHistoryDTO]>.self)
            .map { $0.toDomain() }
    }
    
    func fetchAttendanceHistoryDetails(attendanceHistoryId: AttendanceHistory.ID) -> RxSwift.Single<AttendanceHistory> {
        return network.rx
            .request(.fetchAttendanceHistoryDetails(attendanceHistoryId: attendanceHistoryId))
            .map(BaseResponseDTO<AttendanceHistoryDTO>.self)
            .map { $0.toDomain()! }
    }
    
    func updateAttendanceHistory(attendanceHistoryId: AttendanceHistory.ID) -> RxSwift.Single<Bool> {
        return network.rx
            .request(.updateAttendanceHistory(attendanceHistoryId: attendanceHistoryId))
            .map(BaseResponseDTO<Bool>.self)
            .map { $0.isSuccess }
    }
}
