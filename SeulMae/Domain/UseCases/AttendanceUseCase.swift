//
//  AttendanceUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 8/16/24.
//

import Foundation
import RxSwift

protocol AttendanceRepository {
func attend(request: AttendRequset) -> Single<Bool>  // 출퇴근 승인 요청
func approveAttendance(request: ApproveAttendanceRequest) -> Single<Bool> // 출퇴근 승인 요청 승인
func disapproveAttendance(attendanceHistoryId: AttendanceHistory.ID) ->  Single<Bool> // 거절
func fetchAttendanceRequsetList(workplaceId: Workplace.ID) -> Single<[AttendanceRequest]> // 응답하지 않은 요청
func attend2(request: AttendRequset) -> Single<Bool>// 출퇴근 별도 근무 요청
func fetchAttendanceRequsetList2(workplaceId: Workplace.ID, date: Date) -> Single<[AttendanceRequest]> // 모든 요청 리스트
}

final class DefaultAttendanceRepository: AttendanceRepository {
    
    // MARK: - Dependancies
    
    private let network: AttendanceNetworking
    
    // MARK: - Life Cycle Methods
    
    init(network: AttendanceNetworking) {
        self.network = network
    }
    
    func attend(request: AttendRequset) -> RxSwift.Single<Bool> {
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
    
    func fetchAttendanceRequsetList(workplaceId: Workplace.ID) -> RxSwift.Single<[AttendanceRequest]> {
        return network.rx
            .request(.fetchAttendanceRequsetList(workplaceId: workplaceId))
            .map(BaseResponseDTO<[AttendanceRequestDTO]>.self)
            .map { $0.toDomain() }
    }
    
    func attend2(request: AttendRequset) -> RxSwift.Single<Bool> {
        return network.rx
            .request(.attend2(request: request))
            .map(BaseResponseDTO<Bool>.self)
            .map { $0.isSuccess }
    }
    
    func fetchAttendanceRequsetList2(workplaceId: Workplace.ID, date: Date) -> RxSwift.Single<[AttendanceRequest]> {
        return network.rx
            .request(.fetchAttendanceRequsetList2(workplaceId: workplaceId, date: date))
            .map(BaseResponseDTO<[AttendanceRequestDTO]>.self)
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
    
    func attend(request: AttendRequset) -> Single<Bool>  // 출퇴근 승인 요청
    func approveAttendance(request: ApproveAttendanceRequest) -> Single<Bool> // 출퇴근 승인 요청 승인
    func disapproveAttendance(attendanceHistoryId: AttendanceHistory.ID) ->  Single<Bool> // 거절
    func fetchAttendanceRequsetList() -> Single<[AttendanceRequest]> // 응답하지 않은 요청
    func attend2(request: AttendRequset) -> Single<Bool>// 출퇴근 별도 근무 요청
    func fetchAttendanceRequsetList2(date: Date) -> Single<[AttendanceRequest]> // 모든 요청 리스트
}

final class DefaultAttendanceUseCase: AttendanceUseCase {
    
    private let repository: AttendanceRepository
    private let userRepository = UserRepository(network: UserNetworking())

    init(repository: AttendanceRepository) {
        self.repository = repository
    }
    
    func attend(request: AttendRequset) -> RxSwift.Single<Bool> {
        return repository.attend(request: request)
    }
    
    func approveAttendance(request: ApproveAttendanceRequest) -> RxSwift.Single<Bool> {
        return repository.approveAttendance(request: request)
    }
    
    func disapproveAttendance(attendanceHistoryId: AttendanceHistory.ID) -> RxSwift.Single<Bool> {
        return repository.disapproveAttendance(attendanceHistoryId: attendanceHistoryId)
    }
    
    func fetchAttendanceRequsetList() -> RxSwift.Single<[AttendanceRequest]> {
        let currentWorkplaceId = userRepository.currentWorkplaceId
        return repository.fetchAttendanceRequsetList(workplaceId: currentWorkplaceId)
    }
    
    func attend2(request: AttendRequset) -> RxSwift.Single<Bool> {
        return repository.attend2(request: request)
    }
    
    func fetchAttendanceRequsetList2(date: Date) -> RxSwift.Single<[AttendanceRequest]> {
        let currentWorkplaceId = userRepository.currentWorkplaceId
        return repository.fetchAttendanceRequsetList2(workplaceId: currentWorkplaceId, date: date)
    }

//    func fetchAttendanceRequestList(date: Date) -> RxSwift.Single<[AttendanceListItem]> {
//        repository.fetchAttendanceRequestList(workplaceId: 1, date: date)
//            .map { $0.map(AttendanceListItem.init) }
//    }
}

struct AttendanceRequest: Identifiable {
    let id: Int
    let userName: String
    let userImageURL: String
    let workStartDate: Date
    let workEndDate: Date
    let totalWorkTime: Double
    let isRequestApprove: Bool
    let isManagerCheck: Bool
}

struct AttendanceRequestDTO: ModelType {
    let id: Int
    let userName: String
    let userImageURL: String?
    let workStartDate: Date
    let workEndDate: Date
    let totalWorkTime: Double
    let isRequestApprove: Bool
    let isManagerCheck: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "attendanceRequestHistoryId"
        case userName
        case userImageURL = "userImage"
        case workStartDate = "workStartTime"
        case workEndDate = "workEndTime"
        case totalWorkTime
        case isRequestApprove
        case isManagerCheck
    }
}

extension BaseResponseDTO<[AttendanceRequestDTO]> {
    func toDomain() -> [AttendanceRequest] {
        return data?.map { $0.toDomain() } ?? []
    }
}

extension AttendanceRequestDTO {
    func toDomain() -> AttendanceRequest {
        return .init(
            id: id,
            userName: userName,
            userImageURL: userImageURL ?? "",
            workStartDate: workStartDate,
            workEndDate: workEndDate,
            totalWorkTime: totalWorkTime,
            isRequestApprove: isRequestApprove,
            isManagerCheck: isManagerCheck ?? false
        )
    }
}

