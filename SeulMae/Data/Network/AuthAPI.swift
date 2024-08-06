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
    case requestVerification(phoneNumber: String, email: String? = nil)
    case verifyAuthNumber(authNumber: String)
    case emailVerification(email: String)
    case signin(accountId: String, password: String, fcmToken: String)
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
        case .requestVerification:
            return .post("api/users/phone/sms")
        case .verifyAuthNumber:
            return .post("api/users/phone")
        case .emailVerification:
            return .post("api/users/email")
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
        case let .requestVerification(phoneNumber, email):
            return ["phoneNumber": phoneNumber, "email": email]
        case let .verifyAuthNumber(authNumber):
            return ["authNumber": authNumber]
        case let .emailVerification(email):
            return ["email": email]
        case let .signin(email, password):
            return ["email": email, "password": password]
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
