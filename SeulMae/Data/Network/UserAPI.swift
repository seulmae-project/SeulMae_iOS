//
//  UserAPI.swift
//  SeulMae
//
//  Created by 조기열 on 9/6/24.
//

import Moya
import Foundation

typealias UserNetwork = MoyaProvider<UserAPI>

enum UserAPI: SugarTargetType {
    case myProfile
}

extension UserAPI {
    var baseURL: URL {
        return URL(string: Bundle.main.baseURL)!
    }
    
    var route: Route {
        switch self {
        case .myProfile:
            return .get("api/users/my-profile")
        }
    }
    
    var parameters: Parameters? {
        switch self {
        default:
            return nil
        }
    }
    
    var body: Encodable? {
        switch self {
        default:
            return nil
        }
    }
    
    var data: Data? {
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
}
