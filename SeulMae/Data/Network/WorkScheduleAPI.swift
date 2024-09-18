//
//  WorkScheduleAPI.swift
//  SeulMae
//
//  Created by 조기열 on 9/8/24.
//

import Foundation
import Moya

typealias WorkScheduleNetworking = MoyaProvider<WorkScheduleAPI>



enum WorkScheduleAPI: SugarTargetType {
    case addWorkSchedule(request: AddWorkScheduleRequest)
    case fetchWorkScheduleDetails(workScheduleId: WorkSchedule.ID)
    case updateWorkSchedule(workScheduleId: WorkSchedule.ID, requset: AddWorkScheduleRequest)
    case deleteWorkSchedule(workScheduleId: WorkSchedule.ID)
    case fetchWorkScheduleList(workplaceId: Workplace.ID)
    case addUserToWorkSchedule(workScheduleId: WorkSchedule.ID, memberId: Member.ID)
    case moveUserToWorkSchedule(fromWorkScheduleId: WorkSchedule.ID, toWorkScheduleId: WorkSchedule.ID)
    case fetchUserList(workScheduleId: WorkSchedule.ID)
    case deleteUserFromWorkSchedule(workScheduleId: WorkSchedule.ID)
}

extension WorkScheduleAPI {
    var baseURL: URL {
        return URL(string: Bundle.main.baseURL)!
    }
    
    var route: Route {
        switch self {
        case .addWorkSchedule:
            return .post("api/schedule/v1")
        case .fetchWorkScheduleDetails:
            return .get("api/schedule/v1")
        case .updateWorkSchedule:
            return .put("api/schedule/v1")
        case .deleteWorkSchedule:
            return .delete("api/schedule/v1")
        case .fetchWorkScheduleList:
            return .get("api/schedule/v1/list")
        case .addUserToWorkSchedule:
            return .post("api/user/schedule/v1")
        case .moveUserToWorkSchedule:
            return .patch("api/user/schedule/v1")
        case .fetchUserList:
            return .get("api/user/schedule/v1/list")
        case .deleteUserFromWorkSchedule:
            return .delete("api/user/schedule/v1")
        }
    }
    
    var task: Task {
        switch self {
        case let .addWorkSchedule(request: request):
            return .requestJSONEncodable(request)
        case let .fetchWorkScheduleDetails(workScheduleId: workScheduleId):
            return .requestParameters(
                parameters: [
                    "workScheduleId": workScheduleId
                ],
                encoding: URLEncoding.queryString)
        case let .updateWorkSchedule(workScheduleId: workScheduleId, requset: requset):
            let encoder = JSONEncoder()
            let data = try? encoder.encode(requset)
            return .requestCompositeData(
                bodyData: data!,
                urlParameters: [
                    "workScheduleId": workScheduleId
                ])
        case let .deleteWorkSchedule(workScheduleId: workScheduleId):
            return .requestParameters(
                parameters: [
                    "workScheduleId": workScheduleId
                ],
                encoding: URLEncoding.queryString)
        case let .fetchWorkScheduleList(workplaceId: workplaceId):
            return .requestParameters(
                parameters: [
                    "workplaceId": workplaceId
                ],
                encoding: URLEncoding.queryString)
        case let .addUserToWorkSchedule(workScheduleId: workScheduleId, memberId: memberId):
            return .requestParameters(
                parameters: [
                    "targetUserId": memberId,
                    "workScheduleId": workScheduleId
                ],
                encoding: URLEncoding.queryString)
        case let .moveUserToWorkSchedule(fromWorkScheduleId: fromWorkScheduleId, toWorkScheduleId: toWorkScheduleId):
            return .requestParameters(
                parameters: [
                    "userWorkScheduleId": fromWorkScheduleId
                    // userWorkScheduleId: toWorkScheduleId body!
                ],
                encoding: URLEncoding.queryString)
            return .requestCompositeParameters(
                bodyParameters: [
                    "userWorkScheduleId": toWorkScheduleId
                ],
                bodyEncoding: JSONEncoding.prettyPrinted,
                urlParameters: [
                    "userWorkScheduleId": fromWorkScheduleId
                ])
        case let .fetchUserList(workScheduleId: workScheduleId):
            return .requestParameters(
                parameters: [
                    "workScheduleId": workScheduleId
                ],
                encoding: URLEncoding.queryString)
        case let .deleteUserFromWorkSchedule(workScheduleId: workScheduleId):
            return .requestParameters(
                parameters: [
                    "userWorkScheduleId": workScheduleId
                ],
                encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            let accessToken = UserDefaults.standard.string(forKey: "accessToken")!
            // let refreshToken = UserDefaults.standard.string(forKey: "refreshToken")!
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)",
                // "Authorization-refresh": "Bearer \(refreshToken)"
            ]
        }
    }
}
