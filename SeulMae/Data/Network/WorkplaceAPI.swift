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
    
    case fetchWorkplaceDetail(workplaceID: Workplace.ID)
    case submitApplication(workplaceID: Workplace.ID)
    
    case addNewWorkplace(request: AddNewWorkplaceRequest)
   
    case updateWorkplace(request: UpdateWorkplaceRequest)
    case deleteWorkplace(workplaceID: String)
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
            
        case .fetchWorkplaceDetail:
            return .get("api/workplace/v1/info")
        case .submitApplication:
            return .post("api/workplace/join/v1/request")
            
        case .addNewWorkplace:
            return .post("api/workplace/v1/add")
            
        case .updateWorkplace:
            return .patch("api/workplace/v1/modify")
        case .deleteWorkplace:
            return .post("api/workplace/v1/delete")
      
        case .acceptApplication:
            return .get("api/workplace/join/v1/approval")
        case .denyApplication:
            return .put("api/workplace/join/v1/rejection")
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchWorkplaceDetail(let workplaceID):
            return ["workplaceId": workplaceID]
        case .submitApplication(let workplaceID):
            return Parameters(encoding: URLEncoding.queryString, values: ["workplaceId": workplaceID])
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
        case .addNewWorkplace(request: let request):
            return ["workplaceAddDto": request]
        case .updateWorkplace(request: let request):
            return ["workplaceUpdateDto": request]
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
                "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJBY2Nlc3NUb2tlbiIsImFjY291bnRJZCI6InlvbmdnaXBvIiwiZXhwIjoxNzIzNzQzNTQxfQ.uGGy00NFwPirgMKrALOuclfefmQRP-Kd9iR_9VNgjtkZFt0WjzEdN04jmD0nhlExwpeLOiVZxCEtln0WBjIZkA"
            ]
        }
    }
    
    var data: Data? {
        switch self {
        case .addNewWorkplace(_):
            return Data()
        default:
            return nil
        }
    }
}
