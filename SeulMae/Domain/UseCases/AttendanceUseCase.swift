//
//  AttendanceUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 8/16/24.
//

import Foundation
import RxSwift

protocol AttendanceRepository {
func attend(request: AttendRequest) -> Single<Bool>  // 출퇴근 승인 요청
func approveAttendance(request: ApproveAttendanceRequest) -> Single<Bool> // 출퇴근 승인 요청 승인
func disapproveAttendance(attendanceHistoryId: AttendanceHistory.ID) ->  Single<Bool> // 거절
func fetchAttendanceRequsetList(workplaceId: Workplace.ID) -> Single<[Attendance]> // 응답하지 않은 요청
func attend2(request: AttendRequest) -> Single<Bool>// 출퇴근 별도 근무 요청
func fetchAttendanceRequsetList2(workplaceId: Workplace.ID, date: Date) -> Single<[Attendance]> // 모든 요청 리스트
}

final class DefaultAttendanceRepository: AttendanceRepository {
    
    // MARK: - Dependancies
    
    private let network: AttendanceNetworking
    
    // MARK: - Life Cycle Methods
    
    init(network: AttendanceNetworking) {
        self.network = network
    }
    
    func attend(request: AttendRequest) -> RxSwift.Single<Bool> {
        return network.rx
            .request(.attend(request: request))
            .map(BaseResponseDTO<Bool>.self)
            .map { $0.isSuccess }
    }
    
    func approveAttendance(request: ApproveAttendanceRequest) -> RxSwift.Single<Bool> {
        return network.rx
            .request(.approveAttendance(request: request))
            .map(BaseResponseDTO<Bool>.self)
            .map { $0.isSuccess }
    }
    
    func disapproveAttendance(attendanceHistoryId: AttendanceHistory.ID) -> RxSwift.Single<Bool> {
        return network.rx
            .request(.disapproveAttendance(attendanceHistoryId: attendanceHistoryId))
            .map(BaseResponseDTO<Bool>.self)
            .map { $0.isSuccess }
    }
    
    func fetchAttendanceRequsetList(workplaceId: Workplace.ID) -> RxSwift.Single<[Attendance]> {
        return network.rx
            .request(.fetchAttendanceRequsetList(workplaceId: workplaceId))
            .map(BaseResponseDTO<[AttendanceDTO]>.self)
            .map { $0.toDomain() }
    }
    
    func attend2(request: AttendRequest) -> RxSwift.Single<Bool> {
        return network.rx
            .request(.attend2(request: request))
            .map(BaseResponseDTO<Bool>.self)
            .map { $0.isSuccess }
    }
    
    func fetchAttendanceRequsetList2(workplaceId: Workplace.ID, date: Date) -> RxSwift.Single<[Attendance]> {
        return network.rx
            .request(.fetchAttendanceRequsetList2(workplaceId: workplaceId, date: date))
            .map(BaseResponseDTO<[AttendanceDTO]>.self, using: BaseResponseDTO<[AttendanceDTO]>.decoder)
            .map { $0.toDomain() }
    }
    
//    func fetchAttendanceRequestList(workplaceId: Workplace.ID, date: Date) -> RxSwift.Single<[AttendanceRequest]> {
//        return network.rx
//            .request(.fetchAttendanceRequsetList2(workplaceId: workplaceId, date: date))
//            .do(onSuccess: { response in
//                Swift.print(#function, "response: \(try response.data.prettyString())")
//            }, onError: { error in
//                Swift.print(#function, "error: \(error)")
//            })
//            .map(BaseResponseDTO<[AttendanceRequestDTO]>.self)
//            .map { try $0.toDomain() }
//    }
}

protocol AttendanceUseCase {
    func attend() -> Bool
    func leaveWork(wage: Int) -> Single<Bool>
    
    func attend(request: AttendRequest) -> Single<Bool>  // 출퇴근 승인 요청
    func approveAttendance(request: ApproveAttendanceRequest) -> Single<Bool> // 출퇴근 승인 요청 승인
    func disapproveAttendance(attendanceHistoryId: AttendanceHistory.ID) ->  Single<Bool> // 거절
    func fetchAttendanceRequsetList() -> Single<[Attendance]> // 응답하지 않은 요청
    func attend2(request: AttendRequest) -> Single<Bool>// 출퇴근 별도 근무 요청
    func fetchAttendanceRequsetList2(date: Date) -> Single<[Attendance]> // 모든 요청 리스트
}

final class DefaultAttendanceUseCase: AttendanceUseCase {
    
    private let repository: AttendanceRepository
    private let userRepository = UserRepository(network: UserNetworking())

    init(repository: AttendanceRepository) {
        self.repository = repository
    }

    func attend() -> Bool {
        let userDefaults = UserDefaults.standard
        if let saved = userDefaults.object(forKey: "onAttendance") as? Date {
            return false
        } else {
            let now = Date.ext.now
            userDefaults.set(now, forKey: "onAttendance")
            return true
        }
    }

    func leaveWork(wage: Int) -> Single<Bool> {
        let saved = UserDefaults.standard.object(forKey: "onAttendance")
        guard let start = saved as? Date else {
            return .just(false)
        }

        let end = Date.ext.now
        var attendance = AttendanceService.calculate(start: start, end: end, wage: wage)
        let workplaceId = userRepository.currentWorkplaceId
        attendance.workplaceId = workplaceId
        UserDefaults.standard.removeObject(forKey: "onAttendance")
        return repository.attend(request: attendance)
    }

    func attend(request: AttendRequest) -> RxSwift.Single<Bool> {
        return repository.attend(request: request)
    }
    
    func approveAttendance(request: ApproveAttendanceRequest) -> RxSwift.Single<Bool> {
        return repository.approveAttendance(request: request)
    }
    
    func disapproveAttendance(attendanceHistoryId: AttendanceHistory.ID) -> RxSwift.Single<Bool> {
        return repository.disapproveAttendance(attendanceHistoryId: attendanceHistoryId)
    }
    
    func fetchAttendanceRequsetList() -> RxSwift.Single<[Attendance]> {
        let currentWorkplaceId = userRepository.currentWorkplaceId
        return repository.fetchAttendanceRequsetList(workplaceId: currentWorkplaceId)
    }
    
    func attend2(request: AttendRequest) -> RxSwift.Single<Bool> {
        return repository.attend2(request: request)
    }
    
    func fetchAttendanceRequsetList2(date: Date) -> RxSwift.Single<[Attendance]> {
        let currentWorkplaceId = userRepository.currentWorkplaceId
        return repository.fetchAttendanceRequsetList2(workplaceId: currentWorkplaceId, date: date)
    }

//    func fetchAttendanceRequestList(date: Date) -> RxSwift.Single<[AttendanceListItem]> {
//        repository.fetchAttendanceRequestList(workplaceId: 1, date: date)
//            .map { $0.map(AttendanceListItem.init) }
//    }
}




