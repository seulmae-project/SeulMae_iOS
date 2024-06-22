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
    func signin(_ email: String, _ password: String) -> Single<Token>
    func kakaoSignin() -> Single<Bool>
    
    /// - Tag: Signup
    func emailVerification(_ authCode: String) -> Single<Bool>
    func signup(_ request: SignupRequest) -> Single<Bool>
    
    /// - Tag: Account Recovery
    func recoveryEmail(_ phoneNumber: String) -> Single<Bool>
    func recoveryPassword(_ phoneNumber: String, _ newPassword: String) -> Single<Bool>
    
    /// - Tag: Common
    func smsVerification(_ phoneNumber: String, _ email: String?) -> Single<Bool>
    func authCodeVerification(_ authCode: String) -> Single<Bool>
}

class DefaultAuthUseCase: AuthUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
        
    func signin(_ email: String, _ password: String) -> RxSwift.Single<Token> {
        authRepository.signin(email, password)
    }
    
    func kakaoSignin() -> RxSwift.Single<Bool> {
        authRepository.kakaoSignin()
    }
    
    func emailVerification(_ authCode: String) -> RxSwift.Single<Bool> {
        authRepository.emailVerification(authCode)
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
    
    func smsVerification(_ phoneNumber: String, _ email: String?) -> RxSwift.Single<Bool> {
        authRepository.phoneVerification(phoneNumber, email)
    }
    
    func authCodeVerification(_ authCode: String) -> RxSwift.Single<Bool> {
        authRepository.authCodeVerification(authCode)
    }
}
