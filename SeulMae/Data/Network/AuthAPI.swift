//
//  AuthAPI.swift
//  SeulMae
//
//  Created by 조기열 on 6/14/24.
//

import Foundation
import Moya

typealias AuthNetworking = MoyaProvider<AuthAPI>

enum SMSVerificationType {
    case signUp
    case findAccountId
    case findPaswword
    case changePhoneNumber
}

enum SocialLoginType {
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

struct SetupProfileRequest: ModelType {
    let name: String
    let isMale: Bool
    let birthday: Date // YYYYMMDD
}

enum AuthAPI: SugarTargetType {
    case signup(request: SignupRequest, file: Data)
    case sendSMSCode(phoneNumber: String, item: SMSVerificationItem)
    case verifySMSCode(phoneNumber: String, code: String, item: SMSVerificationItem)
    case verifyAccountId(_ accountId: String)
    case signin(accountId: String, password: String, fcmToken: String)
    case socialLogin(type: SocialLoginType, token: String, fcmToken: String)
    case signout
    case updatePassword(accountId: String, password: String)
    case updateProfile(userId: Member.ID, request: UpdateProfileRequest, file: Data)
    case setupProfile(request: SetupProfileRequest, file: Data) // in case social login
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
        case .signin:
            return .post("api/users/login")
        case .socialLogin:
            return .post("api/users/login/kakao")
        case .signout:
            return .get("api/users/logout")
        case .updatePassword:
            return .put("api/users/pw")
        case .updateProfile:
            return .put("api/users")
        case .setupProfile:
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
        case let .sendSMSCode(phoneNumber: phoneNumber, item: item):
            var parameters = [
                "sendingType": item.smsVerificationType,
                "phoneNumber": phoneNumber
            ]
            if case let .passwordRecovery(account: accountId) = item {
                parameters.updateValue(accountId, forKey: "accountId")
            }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.prettyPrinted)
        case let .verifySMSCode(phoneNumber: phoneNumber, code: code, item: item):
            return .requestParameters(
                parameters: [
                    "sendingType": item.smsVerificationType,
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
                    "fcmToken": fcmToken
                ],
                encoding: JSONEncoding.prettyPrinted)
        case let .socialLogin(type: type, token: token, fcmToken: fcmToken):
            return .requestParameters(
                parameters: [
                    "token": token,
                    "provider": type.provider,
                    "fcmToken": fcmToken
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
        case let .setupProfile(request: requset, file: file):
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
                "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "accessToken"))"
                //Authorization-refresh
            ]
        }
    }
}
