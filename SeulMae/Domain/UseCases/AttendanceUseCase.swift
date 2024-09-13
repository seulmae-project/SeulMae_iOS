//
//  AttendanceUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 8/16/24.
//

import Foundation
import RxSwift

protocol AttendanceRepository {
    func fetchAttendanceRequestList(workplaceId: Workplace.ID, year: Int, month: Int) -> Single<[AttendanceRequest]>
}

final class DefaultAttendanceRepository: AttendanceRepository {
    
    // MARK: - Dependancies
    
    private let network: AttendanceNetworking
    
    // MARK: - Life Cycle Methods
    
    init(network: AttendanceNetworking) {
        self.network = network
    }
    
//    Swift.print(#function, "url: \(response.request?.url)")
//    Swift.print(#function, "httpBody: \(response.request?.httpBody)")
    
    func fetchAttendanceRequestList(workplaceId: Workplace.ID, year: Int, month: Int) -> RxSwift.Single<[AttendanceRequest]> {
        return network.rx
            .request(.fetchAttendanceRequestList(workplaceId: workplaceId, year: year, month: month))
            .do(onSuccess: { response in
                Swift.print(#function, "response: \(try response.data.prettyString())")
            }, onError: { error in
                Swift.print(#function, "error: \(error)")
            })
            .map(BaseResponseDTO<[AttendanceRequestDTO]>.self)
            .map { try $0.toDomain() }
    }
}

protocol AttendanceUseCase {
    // Fetch attendance request list
    func fetchAttendanceRequestList(year: Int, month: Int) -> Single<[AttendanceListItem]>
}

final class DefaultAttendanceUseCase: AttendanceUseCase {
    private let repository: AttendanceRepository
    
    init(repository: AttendanceRepository) {
        self.repository = repository
    }

    func fetchAttendanceRequestList(year: Int, month: Int) -> RxSwift.Single<[AttendanceListItem]> {
        repository.fetchAttendanceRequestList(workplaceId: 1, year: year, month: month)
            .map { $0.map(AttendanceListItem.init) }
    }
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
    func toDomain() throws -> [AttendanceRequest] {
        return try getData().map { $0.toDomain() }
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

