//
//  NotificationAPI.swift
//  SeulMae
//
//  Created by 조기열 on 9/14/24.
//

import Foundation
import Moya

typealias NotificationNetworking = MoyaProvider<NotificationAPI>

enum NotificationAPI: SugarTargetType {
    case fetchNotifications(workplaceId: Workplace.ID)
}

extension NotificationAPI {
    var baseURL: URL {
        return URL(string: Bundle.main.baseURL)!
    }
    
    var route: Route {
        switch self {
        case .fetchNotifications:
            return .get("api/notification/v1)")
        }
    }
    
    var task: Task {
        switch self {
        case let .fetchNotifications(workplaceId: workplaceId):
            return .requestParameters(
                parameters: [
                    "userWorkplaceId": workplaceId
                ],
                encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            let accessToken = UserDefaults.standard.string(forKey: "accessToken")
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken!)"
            ]
        }
    }
}
