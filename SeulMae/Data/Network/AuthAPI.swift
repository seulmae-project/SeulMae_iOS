//
//  AuthAPI.swift
//  SeulMae
//
//  Created by 조기열 on 6/14/24.
//

import Foundation
import Moya

typealias AuthNetworking = MoyaProvider<AuthAPI>

enum AuthAPI: SugarTargetType {
    case signup(SignupRequest)
    case sendSMSCode(phoneNumber: String, email: String? = nil)
    case verifySMSCode(phoneNumber: String, code: String)
    case verifyAccountID(_ accountID: String)
    case signin(accountID: String, password: String, fcmToken: String)
    case socialLogin
    case logout
    case updatePassword(password: String)
    case updateProfile(name: String, imageURL: String)
}

extension AuthAPI {
    var baseURL: URL {
        return URL(string: Bundle.main.baseURL)!
    }
    
    var route: Route {
        switch self {
        case .signup:
            return .post("api/users/pw")
        case .sendSMSCode:
            return .post("api/users/sms-certification/send")
        case .verifySMSCode:
            return .post("api/users/sms-certification/confirm")
        case .verifyAccountID:
            return .post("api/users/id/duplication")
        case .signin:
            return .post("api/users/login")
        case .socialLogin:
            return .post("api/users/login/kakao")
        case .logout:
            return .get("api/users/logout")
        case .updatePassword:
            return .put("api/users/pw")
        case .updateProfile:
            return .put("api/users")
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .signup(let request as ModelType):
            return .init(
                encoding: URLEncoding.queryString,
                values: try! request.asDictionary()
            )
        default:
            return nil
        }
    }
    
    var body: Encodable? {
        switch self {
        case let .sendSMSCode(phoneNumber, email):
            return ["phoneNumber": phoneNumber, "email": email]
        case let .verifySMSCode(phoneNumber, code):
            return ["phoneNumber": phoneNumber, "authCode": code]
        case let .verifyAccountID(accountID):
            return ["accountId": accountID]
        case let .signin(accountID: accountID, password: password, fcmToken: fcmToken):
            return ["accountId": accountID, "password": password, "fcmToken": fcmToken]
        case let .updatePassword(password):
            return ["password": password]
        case let .updateProfile(name, imageURL):
            return ["name": name, "imageURL": imageURL]
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
