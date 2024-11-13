//
//  AuthAPI.swift
//  SeulMae
//
//  Created by 조기열 on 6/14/24.
//

import Foundation
import Moya

typealias AuthNetworking = MoyaProvider<AuthAPI>



enum SocialSigninType {
    case kakao
    case apple
    
    var provider: String {
        switch self {
        case .kakao:
            return "kakao"
        case .apple:
            return "apple"
        }
    }
}

struct UpdateProfileRequest: ModelType {
    let name: String
}

struct SupplementaryProfileInfoDTO: ModelType {
    let name: String
    let isMale: Bool
    let birthday: String // YYYYMMDD
}

enum AuthAPI: SugarTargetType {
    case signup(request: UserInfo, file: Data)
    case sendSMSCode(type: String, name: String, phoneNumber: String)
    case verifySMSCode(phoneNumber: String, code: String, item: SMSVerificationType)
    case verifyAccountId(_ accountId: String)
    case signin(accountId: String, password: String, fcmToken: String?)
    case socialLogin(type: String, token: String, fcmToken: String?)
    case signout
    case updatePassword(accountId: String, password: String)
    case updateProfile(userId: Member.ID, request: UpdateProfileRequest, file: Data)
    case supplementProfileInfo(request: SupplementaryProfileInfoDTO, file: Data) // in case social login
    case cancelAccoount(userId: Member.ID)
    case updatePhoneNumber(userId: Member.ID, phoneNumber: String)
}

extension AuthAPI {
    var baseURL: URL {
        return URL(string: Bundle.main.baseURL)!
    }
    
    var route: Route {
        switch self {
        case .signup:
            return .post("api/users")
        case .sendSMSCode:
            return .post("api/users/sms-certification/send")
        case .verifySMSCode:
            return .post("api/users/sms-certification/confirm")
        case .verifyAccountId:
            return .post("api/users/id/duplication")
        case .signin: return .post("api/users/login")
            
        case .socialLogin: return .post("api/users/social-login")
            
        case .signout:
            return .get("api/users/logout")
        case .updatePassword:
            return .put("api/users/pw")
        case .updateProfile:
            return .put("api/users")
        case .supplementProfileInfo:
            return .put("api/users/extra-profile")
        case .cancelAccoount:
            return .delete("api/users")
        case .updatePhoneNumber:
            return .put("api/users/phone")
        }
    }
    
    var task: Task {
        switch self {
        case let .signup(request: requset, file: file):
            let encoder = JSONEncoder()
            let json = try? encoder.encode(requset)
            return .uploadMultipart(
                [
                    .init(
                        provider: .data(file),
                        name: "file",
                        fileName: "\(arc4random()).jpeg",
                        mimeType: "image/jpeg"),
                    .init(
                        provider: .data(json!),
                        name: "userSignUpDto",
                        mimeType: "application/json"),
                ])
        case let .sendSMSCode(type: type, name: name, phoneNumber: phoneNumber):
            return .requestParameters(
                parameters: [
                    "sendingType": type,
                    "name": name,
                    "phoneNumber": phoneNumber
                ],
                encoding: JSONEncoding.prettyPrinted)
        case let .verifySMSCode(phoneNumber: phoneNumber, code: code, item: item):
            return .requestParameters(
                parameters: [
                    "sendingType": item.sendingType,
                    "phoneNumber": phoneNumber,
                    "authCode": code
                ],
                encoding: JSONEncoding.prettyPrinted)
        case let .verifyAccountId(accountId):
            return .requestParameters(
                parameters: [
                    "accountId": accountId
                ],
                encoding: JSONEncoding.prettyPrinted)
        case let .signin(accountId: accountId, password: password, fcmToken: fcmToken):
            return .requestParameters(
                parameters: [
                    "accountId": accountId,
                    "password": password,
                    "fcmToken": fcmToken ?? ""
                ],
                encoding: JSONEncoding.prettyPrinted)
        case let .socialLogin(type: type, token: token, fcmToken: fcmToken):
            return .requestParameters(
                parameters: [
                    "token": token,
                    "provider": type,
                    "fcmToken": fcmToken ?? ""
                ],
                encoding: JSONEncoding.prettyPrinted)
        case .signout: return .requestPlain
        case let .updatePassword(accountId: accountId, password: password):
            return .requestParameters(
                parameters: [
                    "accountId": accountId,
                    "password": password
                ],
                encoding: JSONEncoding.prettyPrinted)
        case let .updateProfile(userId: userId, request: requset, file: file):
            let encoder = JSONEncoder()
            let json = try? encoder.encode(requset)
            return .uploadCompositeMultipart(
                [
                    .init(
                        provider: .data(file),
                        name: "file",
                        fileName: "\(arc4random()).jpeg",
                        mimeType: "image/jpeg"),
                    .init(
                        provider: .data(json!),
                        name: "userSignUpDto",
                        mimeType: "application/json"),
                ],
                urlParameters: ["id": userId])
        case let .supplementProfileInfo(request: requset, file: file):
            let encoder = JSONEncoder()
            let json = try? encoder.encode(requset)
            return .uploadMultipart(
                [
                    .init(
                        provider: .data(file),
                        name: "file",
                        fileName: "\(arc4random()).jpeg",
                        mimeType: "image/jpeg"),
                    .init(
                        provider: .data(json!),
                        name: "oAuth2AdditionalDataRequest",
                        mimeType: "application/json"),
                ])
        case let .cancelAccoount(userId: userId):
            return .requestParameters(
                parameters: ["id": userId],
                encoding: URLEncoding.queryString)
        case let .updatePhoneNumber(userId: userId, phoneNumber: phoneNumber):
            return .requestCompositeParameters(
                bodyParameters: [
                    "phoneNumber": phoneNumber
                ],
                bodyEncoding: JSONEncoding.prettyPrinted,
                urlParameters: ["id": userId])
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [
                "Content-Type": "application/json",
//                "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "accessToken")!)"
                //Authorization-refresh
            ]
        }
    }
}
