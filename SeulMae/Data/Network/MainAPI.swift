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
    
    case fetchAppNotificationList(userWorkplaceID: Int)
    
    // Announce
    case fetchAnnounceList(workplaceId: Workplace.ID, page: Int, size: Int)
    
    /// - Tag: Notice
    case addNotice(_ request: AddNoticeRequset)
    case updateNotice(noticeID: String, _ request: UpdateNoticeRequest)
    case fetchNoticeDetail(noticeID: String)
    case fetchAllNotice(workplaceID: String, page: Int, size: Int)
    case fetchMustReadNoticeList(workplaceID: Int)
    case fetchMainAnnounceList(workplaceId: Int)
    case deleteNotice(noticeID: Int)
}

extension MainAPI {
    var baseURL: URL {
        return URL(string: Bundle.main.baseURL)!
    }
    
    var route: Route {
        switch self {
        case .fetchAppNotificationList:
            return .get("api/notification/v1/list")
            
        case .fetchMainAnnounceList:
            return .get("api/announcement/v1/main")
        case .fetchAnnounceList:
            return .get("api/announcement/v1/list")
            
        case .fetchMemberList:
            return .get("api/")
        
            
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
    
        case .deleteNotice:
            return .delete("api/announcement/v1")
        }
    }
    
    var parameters: Parameters? {
        switch self {

        case .fetchAppNotificationList(userWorkplaceID: let userWorkplaceID):
            return ["userWorkplaceId": userWorkplaceID]

        case .fetchMainAnnounceList(let workplaceId):
            return ["workplaceId": workplaceId]
        case .fetchAnnounceList(let workplaceId, let page, let size):
            return [
                "workplaceId": workplaceId,
                "page": page,
                "size": size
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
        
        case .deleteNotice(let noticeID):
            return JSONEncoding() => ["announcementId": noticeID]
        default:
            return nil
        }
    }
    
    var body: Encodable? {
        switch self {
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
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "accessToken")!)"
                //Authorization-refresh
            ]
        }
    }
    
    var data: Data? {
        return nil
    }
}
