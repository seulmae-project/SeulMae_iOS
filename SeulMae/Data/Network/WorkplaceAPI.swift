//
//  WorkplaceAPI.swift
//  SeulMae
//
//  Created by 조기열 on 8/13/24.
//

import Moya
import Foundation


typealias WorkplaceNetworking = MoyaProvider<WorkplaceAPI>

enum WorkplaceAPI: SugarTargetType {
    case addWorkplace(request: AddNewWorkplaceRequest, data: Data)
    case fetchWorkplaceList(keyword: String)
    case fetchWorkplaceDetails(workplaceId: Workplace.ID)
    case updateWorkplace(requset: UpdateWorkplaceRequest)
    case deleteWorkplace(workplaceId: Workplace.ID)
    case submitApplication(workplaceId: Workplace.ID)
    case acceptApplication(workplaceApproveId: String, requset: AcceptApplicationRequset)
    case denyApplication(workplaceApproveId: String)
    case fetchApplicationList(workplaceId: Workplace.ID)
    case memberList(workplaceId: Workplace.ID)
    
    case memberDetails(userId: Member.ID)
    case myDetails(workplaceId: Workplace.ID)
    
    case fetchJoinedWorkplaceList
    case promote(requset: PromoteRequset)
    case leaveWorkplace(workplaceId: Workplace.ID)
}

extension WorkplaceAPI {
    var baseURL: URL {
        return URL(string: Bundle.main.baseURL)!
    }
    
    var route: Route {
        switch self {
        case .addWorkplace: return .post("api/workplace/v1/add")
        case .fetchWorkplaceList: return .get("api/workplace/v1/info/all")
        case .fetchWorkplaceDetails: return .get("v1/info")
        case .updateWorkplace: return .patch("api/workplace/v1/modify")
        case .deleteWorkplace: return .delete("api/workplace/v1/delete")
        case .submitApplication: return .post("api/workplace/join/v1/request")
        case .acceptApplication: return .post("api/workplace/join/v1/approval")
        case .denyApplication: return .post("api/workplace/join/v1/rejection")
        case .fetchApplicationList: return .get("api/workplace/join/v1/request/list")
        case .memberList: return .get("api/workplace/user/v1/list")
        case .memberDetails: return .get("api/workplace/user/v1")
        case .myDetails: return .get("api/workplace/user/v1/self")
        case .fetchJoinedWorkplaceList: return .get("api/workplace/v1/info/join")
        case .promote: return .post("api/workplace/user/v1/manager/delegate")
        case .leaveWorkplace: return .delete("api/workplace/user/v1/list")
        }
    }
    
    var task: Task {
        switch self {
        case let .addWorkplace(request: requset, data: data):
            let encoder = JSONEncoder()
            let json = try? encoder.encode(requset)
            return .uploadMultipart(
                [
                    .init(
                        provider: .data(data),
                        name: "multipartFileList",
                        fileName: "\(arc4random()).jpeg",
                        mimeType: "image/jpeg"),
                    .init(
                        provider: .data(json!),
                        name: "workplaceAddDto",
                        mimeType: "application/json"),
                ])
        case let .fetchWorkplaceList(keyword: keyword):
            return .requestParameters(
                parameters: [
                    "keyword": keyword
                ],
                encoding: URLEncoding.queryString)
        case let .fetchWorkplaceDetails(workplaceId: workplaceId):
            return .requestParameters(
                parameters: [
                    "workplaceId": workplaceId
                ],
                encoding: URLEncoding.queryString)
        case let .updateWorkplace(requset: requset):
            let encoder = JSONEncoder()
            let json = try? encoder.encode(requset)
            return .uploadMultipart(
                [
//                    .init(
//                        provider: .data(data),
//                        name: "multipartFileList",
//                        fileName: "\(arc4random()).jpeg",
//                        mimeType: "image/jpeg"),
                    .init(
                        provider: .data(json!),
                        name: "workplaceModifyDto",
                        mimeType: "application/json"),
                ])
        case let .deleteWorkplace(workplaceId: workplaceId):
            return .requestParameters(
                parameters: [
                    "workplaceId": workplaceId
                ],
                encoding: URLEncoding.queryString)
        case let .submitApplication(workplaceId: workplaceId):
            return .requestParameters(
                parameters: [
                    "workplaceId": workplaceId
                ],
                encoding: URLEncoding.httpBody)
        case let .acceptApplication(workplaceApproveId: workplaceApproveId, requset: requset):
            let encoder = JSONEncoder()
            let json = try? encoder.encode(requset)
            return .requestCompositeData(
                bodyData: json!,
                urlParameters: [
                    "workplaceApproveId": workplaceApproveId
                ])
        case let .denyApplication(workplaceApproveId: workplaceApproveId):
            return .requestParameters(
                parameters: [
                    "workplaceApproveId": workplaceApproveId
                ],
                encoding: URLEncoding.httpBody)
        case let .fetchApplicationList(workplaceId: workplaceId):
            return .requestParameters(
                parameters: [
                    "workplaceId": workplaceId
                ],
                encoding: URLEncoding.queryString)
        case let .memberList(workplaceId: workplaceId):
            return .requestParameters(
                parameters: [
                    "workplaceId": workplaceId
                ],
                encoding: URLEncoding.queryString)
        case let .memberDetails(userId: userId):
            return .requestParameters(
                parameters: [
                    "userWorkplaceId": userId
                ],
                encoding: URLEncoding.queryString)
        case let .myDetails(workplaceId: workplaceId):
            return .requestParameters(
                parameters: [
                    "workplaceId": workplaceId
                ],
                encoding: URLEncoding.queryString)
            
        case .fetchJoinedWorkplaceList:
            return .requestPlain
        case let .promote(requset: requset):
            return .requestJSONEncodable(requset)
        case let .leaveWorkplace(workplaceId: workplaceId):
            return .requestParameters(
                parameters: [
                    "workplaceId": workplaceId
                ],
                encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            // TODO: - Handle authorization code
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"
            ]
        }
    }
}
