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
    func signin(email: String, password: String, fcmToken: String) -> Single<Bool>
    func socialSignin(type: SocialSigninType, token: String) -> Single<Credentials>
    
    // Signup
    func verifyAccountID(_ accountID: String) -> Single<Bool>
    func signup(request: SignupRequest, file: Data) -> Single<Bool>
    
    // Credential Recovery
    func recoveryEmail(_ phoneNumber: String) -> Single<Bool>
    func recoveryPassword(_ phoneNumber: String, _ newPassword: String) -> Single<Bool>
    
    // Common
    func sendSMSCode(type: String, phoneNumber: String, accountId: String?) -> Single<Bool>
    func verifySMSCode(phoneNumber: String, code: String) -> Single<Bool>
}

class DefaultAuthUseCase: AuthUseCase {
    
    private let authRepository: AuthRepository
    private let workplaceRepository: WorkplaceRepository
    
    init(authRepository: AuthRepository, workplaceRepository: WorkplaceRepository) {
        self.authRepository = authRepository
        self.workplaceRepository = workplaceRepository
    }
        
    func signin(email: String, password: String, fcmToken: String) -> RxSwift.Single<Bool> {
        return authRepository.signin(account: email, password: password, fcmToken: fcmToken)
            .map { [weak self] response in
                guard let strongSelf = self else { return false }
                let _ = strongSelf.workplaceRepository
                    .saveWorkplaces(response.workplace, withAccount: email)
                    .do(onSuccess: { isSaved in
                        Swift.print("isSaved: \(isSaved)")
                    })
                
                Swift.print(#line, String("token: \(response.token.accessToken.suffix(5))"))

                // Save acount
                UserDefaults.standard.setValue(email, forKey: "account")
                // Save token
                UserDefaults.standard.setValue(response.token.accessToken, forKey: "accessToken")
                UserDefaults.standard.setValue(response.token.refreshToken, forKey: "refreshToken")
                return true
            }
    }
    
    func socialSignin(type: SocialSigninType, token: String) -> RxSwift.Single<Credentials> {
        let fcmToken = ""
        return authRepository.socialSignin(type: type, token: token, fcmToken: fcmToken)
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
    
    func sendSMSCode(type: String, phoneNumber: String, accountId: String?) -> RxSwift.Single<Bool> {
        return authRepository.sendSMSCode(type: type, phoneNumber: phoneNumber, accountId: accountId)
    }
    
    func verifySMSCode(phoneNumber: String, code: String) -> RxSwift.Single<Bool> {
        authRepository.verifySMSCode(phoneNumber: phoneNumber, code: code)
    }
}
