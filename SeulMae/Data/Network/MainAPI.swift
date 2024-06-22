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
    
}

extension MainAPI {
    var baseURL: URL {
        return URL(string: Secrets.BASE_URL)!
    }
    
    var route: Route {
        switch self {
        default:
            return .post("api/users/pw")
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
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
