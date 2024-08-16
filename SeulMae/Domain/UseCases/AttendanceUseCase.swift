//
//  AttendanceUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 8/16/24.
//

import Foundation
import RxSwift
import Moya

typealias AttendanceNetworking = MoyaProvider<AttendanceAPI>

enum AttendanceAPI: SugarTargetType {
    case fetchAttendanceRequestList(workplaceID: Workplace.ID, date: Date)
}

extension AttendanceAPI {
    var baseURL: URL {
        return URL(string: Bundle.main.baseURL)!
    }
    
    var route: Route {
        switch self {
        case .fetchAttendanceRequestList:
            return .get("api/attendance/v1/main/manager")
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .fetchAttendanceRequestList(workplaceID, date):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return [
                "workplaceId": workplaceID,
                "localDate": dateFormatter.string(from: date)
            ]
        default:
            return nil
        }
    }
    
    var body: Encodable? {
        switch self {
        default:
            return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            // TODO: - Handle authorization code
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "accessToken"))"
            ]
        }
    }
    
    var data: Data? {
        switch self {
        default:
            return nil
        }
    }
}


protocol AttendanceRepository {
    func fetchAttendanceRequestList(workplaceID: Workplace.ID, date: Date) -> Single<[AttendanceRequest]>
}

final class DefaultAttendanceRepository: AttendanceRepository {
    
    // MARK: - Dependancies
    
    private let network: AttendanceNetworking
    
    // MARK: - Life Cycle Methods
    
    init(network: AttendanceNetworking) {
        self.network = network
    }
    
    func fetchAttendanceRequestList(workplaceID: Workplace.ID, date: Date) -> RxSwift.Single<[AttendanceRequest]> {
        return network.rx
            .request(.fetchAttendanceRequestList(workplaceID: workplaceID, date: date))
            .do(onSuccess: { response in
                Swift.print(#function, "response: \(try response.data.prettyString())")
            }, onError: { error in
                Swift.print(#function, "error: \(error)")
            })
            .map(BaseResponseDTO<[AttendanceRequestDTO]>.self)
            .map { $0.toDomain() }
    }
}

protocol AttendanceUseCase {
    // Fetch attendance request list
    func fetchAttendanceRequestList(workplaceID: Workplace.ID, date: Date) -> Single<[AttendanceRequest]>
}

final class DefaultAttendanceUseCase: AttendanceUseCase {
    private let repository: AttendanceRepository
    
    init(repository: AttendanceRepository) {
        self.repository = repository
    }

    func fetchAttendanceRequestList(workplaceID: Workplace.ID, date: Date) -> RxSwift.Single<[AttendanceRequest]> {
        repository.fetchAttendanceRequestList(workplaceID: workplaceID, date: date)
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
    func toDomain() -> [AttendanceRequest] {
        data?.map { $0.toDomain() } ?? []
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

