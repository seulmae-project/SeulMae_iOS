//
//  WorkScheduleAPI.swift
//  SeulMae
//
//  Created by 조기열 on 9/8/24.
//

import Foundation
import Moya

typealias WorkScheduleNetworking = MoyaProvider<WorkScheduleAPI>

enum WorkScheduleAPI: SugarTargetType {
    case fetchWorkScheduleList(workplaceId: Workplace.ID)
}

extension WorkScheduleAPI {
    var baseURL: URL {
        return URL(string: Bundle.main.baseURL)!
    }
    
    var route: Route {
        switch self {
        case .fetchWorkScheduleList: return .get("api/schedule/v1/list")
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchWorkScheduleList(workplaceId: let workplaceId):
            return ["workplaceId": workplaceId]
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
    
    var data: Data? {
        return nil
    }
}
