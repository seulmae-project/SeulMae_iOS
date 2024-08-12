//
//  MainAPI.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import Foundation
import Moya

typealias MainNetworking = MoyaProvider<MainAPI>

enum MainAPI: SugarTargetType {
    
    /// - Tag: Main
    case fetchMemberList(_ workplaceID: String)
    
    /// - Tag: Workplace
    case addWorkplace(_ request: AddWorkplaceRequest)
    case fetchWorkplaceList(keyword: String)
    case fetchWorkplaceDetail(workplaceID: String)
    case updateWorkplace(_ request: UpdateWorkplaceRequest)
    case deleteWorkplace(workplaceID: String)
    case submitApplication(workplaceID: String)
    case acceptApplication(workplaceApproveId: String, workplaceJoinHistoryId: String)
    case denyApplication(workplaceApproveId: String, workplaceJoinHistoryId: String)
    
    /// - Tag: Remainder
    case addNotice(_ request: AddNoticeRequset)
    case updateNotice(noticeID: String, _ request: UpdateNoticeRequest)
    case fetchNoticeDetail(noticeID: String)
    case fetchAllNotice(workplaceID: String, page: Int, size: Int)
    case fetchMustReadNoticeList(workplaceID: Int)
    case fetchMainNoticeList(workplaceID: Int)
    case deleteNotice(noticeID: Int)
}

extension MainAPI {
    var baseURL: URL {
        return URL(string: Bundle.main.baseURL)!
    }
    
    var route: Route {
        switch self {
        case .fetchMemberList:
            return .get("api/")
            
        case .addWorkplace(_):
            return .post("api/workplace/v1/add")
        case .fetchWorkplaceList:
            return .get("api/workplace/v1/info/all")
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
            
        case .addNotice:
            return .post("api/announcement/v1")
        case .updateNotice:
            return .put("api/announcement/v1")
        case .fetchNoticeDetail:
            return .get("api/announcement/v1")
        case .fetchAllNotice:
            return .get("api/announcement/v1/list")
        case .fetchMustReadNoticeList:
            return .get("api/announcement/v1/list/important")
        case .fetchMainNoticeList:
            return .get("api/announcement/v1/main")
        case .deleteNotice:
            return .delete("api/announcement/v1")
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
            
        case .updateNotice(let noticeID, _):
            return JSONEncoding() => ["announcementId": noticeID]
        case .fetchNoticeDetail(let noticeID):
            return JSONEncoding() => ["announcementId": noticeID]
        case .fetchAllNotice(let workplaceID, let page, let size):
            return JSONEncoding() => [
                "workplaceId": workplaceID,
                "page": page,
                "size": size
            ]
        case .fetchMustReadNoticeList(let workplaceID):
            return JSONEncoding() => ["workplaceId": workplaceID]
        case .fetchMainNoticeList(let workplaceID):
            return JSONEncoding() => ["workplaceId": workplaceID]
        case .deleteNotice(let noticeID):
            return JSONEncoding() => ["announcementId": noticeID]
        default:
            return nil
        }
    }
    
    var body: Encodable? {
        switch self {
        case .addWorkplace(let request): 
            return request
        case .updateWorkplace(let request):
            return request
        case .submitApplication(let request):
            return request
            
        case .addNotice(let request):
            return request
        case .updateNotice(_, let request):
            return request
        default:
            return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var data: Data? {
        return nil
    }
}
