//
//  AuthUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import Foundation
import RxSwift

protocol AuthUseCase {
    // Signin
    func signin(accountId: String, password: String) -> Single<Credentials>
    func socialSignin(type: SocialSigninType, token: String) -> Single<Credentials>

    // Signup
    func verifyAccountID(_ accountID: String) -> Single<Bool>
    func signup(request: SignupRequest, file: Data) -> Single<Bool>
    
    // Credential Recovery
    func recoveryEmail(_ phoneNumber: String) -> Single<Bool>
    func recoveryPassword(_ phoneNumber: String, _ newPassword: String) -> Single<Bool>
    
    // Common
    func sendSMSCode(type: SMSVerificationType, name: String, phoneNumber: String) -> RxSwift.Single<SMSRequestStatus>
    func verifySMSCode(phoneNumber: String, code: String) -> Single<Bool>

    func setupProfile(request: SupplementaryProfileInfoDTO, file: Data) -> Single<Bool> // in case social login
}

class DefaultAuthUseCase: AuthUseCase {
    private let authRepository: AuthRepository
    private let workplaceRepository: WorkplaceRepository
    private let userRepository: UserRepository

    init(
        dependencies: (
            authRepository: AuthRepository,
            userRepository: UserRepository,
            workplaceRepository: WorkplaceRepository
        )
    ) {
        self.authRepository = dependencies.authRepository
        self.userRepository = dependencies.userRepository
        self.workplaceRepository = dependencies.workplaceRepository
    }

    func signin(accountId: String, password: String) -> RxSwift.Single<Credentials> {
        let fcmToken = userRepository.fcmToken
        return authRepository.signin(account: accountId, password: password, fcmToken: fcmToken)
            .do(onSuccess: { [weak self] credentials in
                // Save workplaces
                _ = self?.workplaceRepository.create(workplaceList: credentials.workplace, accountId: accountId)
                // Save account id
                UserDefaults.standard.setValue(accountId, forKey: "accountId")
                // Save tokens
                self?.userRepository.saveToken(credentials.token)
            })
    }
    
    enum SocialSigninRole: String {
        case guest = "GUEST"
        case user = "USER"
        
        var isGuest: Bool {
            return (self == .guest)
        }
    }
    
    func socialSignin(type: SocialSigninType, token: String) -> RxSwift.Single<Credentials> {
        let fcmToken = userRepository.fcmToken
        return authRepository.socialSignin(type: type, token: token, fcmToken: fcmToken)
            .do(onSuccess: { [weak self] credentials in
                // Save workplaces
                _ = self?.workplaceRepository.create(workplaceList: credentials.workplace, accountId: type.provider)
                UserDefaults.standard.setValue(type.provider, forKey: "accountId")
                // Save tokens
                self?.userRepository.saveToken(credentials.token)
            })
    }
    
    func verifyAccountID(_ accountID: String) -> RxSwift.Single<Bool> {
        authRepository.verifyAccountID(accountID)
    }
    
    func signup(request: SignupRequest, file: Data) -> RxSwift.Single<Bool> {
        authRepository.signup(request: request, file: file)
    }
    
    func recoveryEmail(_ phoneNumber: String) -> RxSwift.Single<Bool> {
        authRepository.recoveryEmail(phoneNumber)
    }
    
    func recoveryPassword(_ phoneNumber: String, _ newPassword: String) -> RxSwift.Single<Bool> {
        authRepository.recoveryPassword(phoneNumber, newPassword)
    }
    
    func sendSMSCode(type: SMSVerificationType, name: String, phoneNumber: String) -> RxSwift.Single<SMSRequestStatus> {
        let logKey = "sendLogs"

        let now = Date.ext.now.timeIntervalSince1970
        let expiration = now - 1_800
        var sendLogs = UserDefaults.standard.array(forKey: logKey) as? [TimeInterval] ?? []
        let sendCount = sendLogs.filter { $0 >= expiration }.count
        if (sendCount >= 3) {
            return .just(.invalid)
        }

        sendLogs.append(now)
        UserDefaults.standard.set(sendLogs, forKey: logKey)
        return authRepository.sendSMSCode(type: type.sendingType, name: name, phoneNumber: phoneNumber)
            .map { 
                if $0 {
                    return (sendCount == 0) ? .request : .reRequest
                } else {
                    return .invalid
                }
            }
    }

    func saveSendLog(_ logs: [Date]) {
        let timestamps = logs.map { $0.timeIntervalSince1970 }
        UserDefaults.standard.set(timestamps, forKey: "dateArray")
    }




    func verifySMSCode(phoneNumber: String, code: String) -> RxSwift.Single<Bool> {
        authRepository.verifySMSCode(phoneNumber: phoneNumber, code: code)
    }
    
    func setupProfile(request: SupplementaryProfileInfoDTO, file: Data) -> Single<Bool> {
        return authRepository.supplementProfileInfo(profileInfoDTO: request, userImageData: file)
    }
}
