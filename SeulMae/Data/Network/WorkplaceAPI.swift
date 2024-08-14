//
//  WorkplaceAPI.swift
//  SeulMae
//
//  Created by 조기열 on 8/13/24.
//

import struct Foundation.URL
import class Foundation.Bundle
import struct Foundation.Data
import Moya


typealias WorkplaceNetworking = MoyaProvider<WorkplaceAPI>

enum WorkplaceAPI: SugarTargetType {
    case fetchWorkplaces(keyword: String)
    case addNewWorkplace(request: AddWorkplaceRequest)
    case fetchWorkplaceDetail(workplaceID: String)
    case updateWorkplace(request: UpdateWorkplaceRequest)
    case deleteWorkplace(workplaceID: String)
    case submitApplication(workplaceID: String)
    case acceptApplication(workplaceApproveId: String, workplaceJoinHistoryId: String)
    case denyApplication(workplaceApproveId: String, workplaceJoinHistoryId: String)
}

extension WorkplaceAPI {
    var baseURL: URL {
        return URL(string: Bundle.main.baseURL)!
    }
    
    var route: Route {
        switch self {
        case .fetchWorkplaces:
            return .get("api/workplace/v1/info/all")
        case .addNewWorkplace:
            return .post("api/workplace/v1/add")
        case .fetchWorkplaceDetail:
            return .get("api/workplace/v1/info")
        case .updateWorkplace:
            return .patch("api/workplace/v1/modify")
        case .deleteWorkplace:
            return .post("api/workplace/v1/delete")
        case .submitApplication:
            return .post("api/workplace/join/v1/request")
        case .acceptApplication:
            return .get("api/workplace/join/v1/approval")
        case .denyApplication:
            return .put("api/workplace/join/v1/rejection")
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchWorkplaceDetail(let workplaceId):
            return JSONEncoding() => ["workplaceId": workplaceId]
        case .deleteWorkplace(let workplaceId):
            return JSONEncoding() => ["workplaceId": workplaceId]
        case .acceptApplication(let workplaceApproveId, let workplaceJoinHistoryId):
            return JSONEncoding() => [
                "workplaceApproveId": workplaceApproveId,
                "workplaceJoinHistoryId": workplaceJoinHistoryId
            ]
        case .denyApplication(let workplaceApproveId, let workplaceJoinHistoryId):
            return JSONEncoding() => [
                "workplaceApproveId": workplaceApproveId,
                "workplaceJoinHistoryId": workplaceJoinHistoryId
            ]
        default:
            return nil
        }
    }
    
    var body: Encodable? {
        switch self {
        case .addNewWorkplace(request: let request as ModelType),
                .updateWorkplace(request: let request as ModelType):
            return request
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
                "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJBY2Nlc3NUb2tlbiIsImFjY291bnRJZCI6InlvbmdnaXBvIiwiZXhwIjoxNzIzNjI1NjQ3fQ.w5iTs_FFI2v4FP9OOFpacRoffHiB6JD4BNTpYwXQZblS1DWfOJ3wu1IT3a9IuIxqwBi33sZGnlA2kkeCRXTCpg"
            ]
        }
    }
    
    var data: Data? {
        return nil
    }
}
