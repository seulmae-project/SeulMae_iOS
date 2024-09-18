//
//  AnnounceAPI.swift
//  SeulMae
//
//  Created by 조기열 on 9/15/24.
//

import Foundation
import Moya

typealias AnnounceNetworking = MoyaProvider<AnnounceAPI>

enum AnnounceAPI: SugarTargetType {
    case addAnnounce(request: AddAnnounceRequset)
    case updateAnnounce(announceId: Announce.ID, request: UpdateAnnounceRequest)
    case fetchAnnounceDetail(announceId: Announce.ID)
    case fetchAnnounceList(workplaceId: Workplace.ID, page: Int, size: Int)
    case fetchImportantAnnounceList(workplaceId: Workplace.ID)
    case fetchMainAnnounceList(workplaceId: Workplace.ID)
    case deleteAnnounce(announceId: Announce.ID)
}

extension AnnounceAPI {
    var baseURL: URL {
        return URL(string: Bundle.main.baseURL)!
    }
    
    var route: Route {
        switch self {
        case .addAnnounce: return .get("api/announcement/v1")
        case .updateAnnounce: return .put("api/announcement/v1")
        case .fetchAnnounceDetail: return .get("api/announcement/v1")
        case .fetchAnnounceList: return .get("api/announcement/v1/list")
        case .fetchImportantAnnounceList: return .get("api/announcement/v1/list/important")
        case .fetchMainAnnounceList: return .get("api/announcement/v1/main")
        case .deleteAnnounce: return .delete("api/announcement/v1")
        }
    }
    
    var task: Task {
        switch self {
        case let .addAnnounce(request: request):
            return .requestJSONEncodable(request)
        case let .updateAnnounce(announceId: announceId, request: request):
            let encoder = JSONEncoder()
            let data = try? encoder.encode(request)
            return .requestCompositeData(
                bodyData: data!,
                urlParameters: [
                    "announcementId": announceId
                ])
        case let .fetchAnnounceDetail(announceId: announceId):
            return .requestParameters(
                parameters: [
                    "announcementId": announceId
                ],
                encoding: URLEncoding.queryString)
        case let .fetchAnnounceList(workplaceId: workplaceId, page: page, size: size):
            return .requestParameters(
                parameters: [
                    "workplaceId": workplaceId,
                    "page": page,
                    "size": size
                ],
                encoding: URLEncoding.queryString)
        case let .fetchImportantAnnounceList(workplaceId: workplaceId):
            return .requestParameters(
                parameters: [
                    "workplaceId": workplaceId
                ],
                encoding: URLEncoding.queryString)
        case let .fetchMainAnnounceList(workplaceId: workplaceId):
            return .requestParameters(
                parameters: [
                    "workplaceId": workplaceId
                ],
                encoding: URLEncoding.queryString)
        case let .deleteAnnounce(announceId: announceId):
            return .requestParameters(
                parameters: [
                    "announcementId": announceId
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
