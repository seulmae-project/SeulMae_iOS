//
//  WorkScheduleAPI.swift
//  SeulMae
//
//  Created by 조기열 on 9/8/24.
//

import Foundation
import Moya

typealias WorkScheduleNetworking = MoyaProvider<WorkScheduleAPI>

struct AddWorkScheduleRequest: ModelType {
    
}

enum WorkScheduleAPI: SugarTargetType {
    case addWorkSchedule(request: AddWorkScheduleRequest)
    case fetchWorkScheduleDetails(workScheduleId: WorkSchedule.ID)
    case updateWorkSchedule(workScheduleId: WorkSchedule.ID, requset: AddWorkScheduleRequest)
    case deleteWorkSchedlue(workScheduleId: WorkSchedule.ID)
    case fetchWorkScheduleList(workplaceId: Workplace.ID)
    case addUserToWorkSchedule(workScheduleId: WorkSchedule.ID, memberId: Member.ID)
    case moveUserToWorkSchedule(fromWorkScheduleId: WorkSchedule.ID, toWorkScheduleId: WorkSchedule.ID)
    case fetchUserList(workScheduleId: WorkSchedule.ID)
    case deleteUserFromWorkSchedlue(workScheduleId: WorkSchedule.ID)
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
        case .deleteWorkSchedlue:
            return .delete("api/schedule/v1")
        case .fetchWorkScheduleList:
            return .get("api/schedule/v1/list")
        case .addUserToWorkSchedule:
            return .post("api/user/schedule/v1")
        case .moveUserToWorkSchedule:
            return .patch("api/user/schedule/v1")
        case .fetchUserList:
            return .get("api/user/schedule/v1/list")
        case .deleteUserFromWorkSchedlue:
            return .delete("api/user/schedule/v1")
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .addWorkSchedule(request: request):
            return JSONEncoding() => (try! request.asDictionary())
        case let .fetchWorkScheduleDetails(workScheduleId: workScheduleId):
            return [
                "workScheduleId": workScheduleId
            ]
        case let .updateWorkSchedule(workScheduleId: workScheduleId, requset: requset):
            return [
                "workScheduleId": workScheduleId
                // requset
            ]
        case let .deleteWorkSchedlue(workScheduleId: workScheduleId):
            return [
                "workScheduleId": workScheduleId
            ]
        case let .fetchWorkScheduleList(workplaceId: workplaceId):
            return [
                "workplaceId": workplaceId
            ]
        case let .addUserToWorkSchedule(workScheduleId: workScheduleId, memberId: memberId):
            return [
                "targetUserId": memberId,
                "workScheduleId": workScheduleId
            ]
        case let .moveUserToWorkSchedule(fromWorkScheduleId: fromWorkScheduleId, toWorkScheduleId: toWorkScheduleId):
            return [
                "userWorkScheduleId": fromWorkScheduleId
                // userWorkScheduleId: toWorkScheduleId body!
            ]
        case let .fetchUserList(workScheduleId: workScheduleId):
            return [
                "workScheduleId": workScheduleId
            ]
        case let .deleteUserFromWorkSchedlue(workScheduleId: workScheduleId):
            return [
                "userWorkScheduleId": workScheduleId
            ]
        }
    }
    
    var body: Encodable? {
        switch self {
        default:
            return nil
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
    
    var data: Data? {
        return nil
    }
}
