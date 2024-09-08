//
//  MemberNetworking.swift
//  SeulMae
//
//  Created by 조기열 on 9/8/24.
//

import Foundation
import Moya

typealias MemberNetworking = MoyaProvider<MemberAPI>

enum MemberAPI: SugarTargetType {
    case fetchMemberList(workplaceId: Workplace.ID)
    // case fetchMemberProfile(memberId: Member.ID)
    case fetchMemberProfile(memberId: Member.ID)
}

extension MemberAPI {
    var baseURL: URL {
        return URL(string: Bundle.main.baseURL)!
    }
    
    var route: Route {
        switch self {
        case .fetchMemberList: return .get("api/workplace/user/v1/list")
        case .fetchMemberProfile: return .get("api/workplace/user/v1")
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchMemberList(workplaceId: let workplaceId):
            return ["workplace": workplaceId]
        case .fetchMemberProfile(let memberId):
            return ["userWorkplaceId": memberId]
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
