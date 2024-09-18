//
//  UserAPI.swift
//  SeulMae
//
//  Created by 조기열 on 9/6/24.
//

import Moya
import Foundation

typealias UserNetworking = MoyaProvider<UserAPI>

enum UserAPI: SugarTargetType {
    case fetchUserProfile(userId: Member.ID)
    case fetchMyProfile
}

extension UserAPI {
    var baseURL: URL {
        return URL(string: Bundle.main.baseURL)!
    }
    
    var route: Route {
        switch self {
        case .fetchUserProfile:
            return .get("api/users")
        case .fetchMyProfile:
            return .get("api/users/my-profile")
        }
    }
    
    var task: Task {
        switch self {
        case let .fetchUserProfile(userId: userId):
            return .requestParameters(
                parameters: [
                    "id": userId
                ],
                encoding: URLEncoding.queryString)
        case let .fetchMyProfile:
            return .requestPlain
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
