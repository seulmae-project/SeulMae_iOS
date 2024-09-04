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
    
    // Noti
    case fetchAppNotificationList(userWorkplaceID: Int)
    
    // Announce
    case fetchAnnounceList(workplaceId: Workplace.ID, page: Int, size: Int)
    case fetchAnnounceDetail(announceId: Announce.ID)
    case updateAnnounce(announceId: Announce.ID, request: UpdateAnnounceRequest)
    case addAnnounce(request: AddAnnounceRequset)
    
    /// - Tag: Notice
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
        case .addAnnounce:
            return .post("api/announcement/v1")
        case .updateAnnounce:
            return .put("api/announcement/v1")
            
        case .fetchMemberList:
            return .get("api/")
        
            
        
        case .fetchAnnounceDetail:
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
        case .fetchAnnounceDetail(let announceId):
            return ["announcementId": announceId]
        case .updateAnnounce(let announceId, _):
            return ["announcementId": announceId]

        
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
        case .addAnnounce(let request):
            return request
        case .updateAnnounce(_, let request):
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
