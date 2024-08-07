//
//  AuthUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import Foundation
import RxSwift

protocol AuthUseCase {
    /// - Tag: Signin
    func signin(email: String, password: String, fcmToken: String) -> Single<AuthData>
    func kakaoSignin() -> Single<Bool>
    
    /// - Tag: Signup
    func verifyAccountID(_ accountID: String) -> Single<Bool>
    func signup(_ request: SignupRequest) -> Single<Bool>
    
    /// - Tag: Account Recovery
    func recoveryEmail(_ phoneNumber: String) -> Single<Bool>
    func recoveryPassword(_ phoneNumber: String, _ newPassword: String) -> Single<Bool>
    
    /// - Tag: Common
    func sendSMSCode(phoneNumber: String, email: String?) -> Single<String>
    func verifySMSCode(phoneNumber: String, code: String) -> Single<Bool>
}

class DefaultAuthUseCase: AuthUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
        
    func signin(email: String, password: String, fcmToken: String) -> RxSwift.Single<AuthData> {
        authRepository.signin(account: email, password: password, fcmToken: fcmToken)
    }
    
    func kakaoSignin() -> RxSwift.Single<Bool> {
        authRepository.kakaoSignin()
    }
    
    func verifyAccountID(_ accountID: String) -> RxSwift.Single<Bool> {
        authRepository.verifyAccountID(accountID)
    }
    
    func signup(_ request: SignupRequest) -> RxSwift.Single<Bool> {
        authRepository.signup(request)
    }
    
    func recoveryEmail(_ phoneNumber: String) -> RxSwift.Single<Bool> {
        authRepository.recoveryEmail(phoneNumber)
    }
    
    func recoveryPassword(_ phoneNumber: String, _ newPassword: String) -> RxSwift.Single<Bool> {
        authRepository.recoveryPassword(phoneNumber, newPassword)
    }
    
    func sendSMSCode(phoneNumber: String, email: String?) -> RxSwift.Single<String> {
        authRepository.sendSMSCode(phoneNumber: phoneNumber, email: email)
    }
    
    func verifySMSCode(phoneNumber: String, code: String) -> RxSwift.Single<Bool> {
        authRepository.verifySMSCode(phoneNumber: phoneNumber, code: code)
    }
}
