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
    func signin(email: String, password: String, fcmToken: String) -> Single<Bool>
    func kakaoSignin() -> Single<Bool>
    
    /// - Tag: Signup
    func verifyAccountID(_ accountID: String) -> Single<Bool>
    func signup(request: SignupRequest, file: Data) -> Single<Bool>
    
    /// - Tag: Account Recovery
    func recoveryEmail(_ phoneNumber: String) -> Single<Bool>
    func recoveryPassword(_ phoneNumber: String, _ newPassword: String) -> Single<Bool>
    
    /// - Tag: Common
    func sendSMSCode(phoneNumber: String, email: String?) -> Single<String>
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
    
    func kakaoSignin() -> RxSwift.Single<Bool> {
        authRepository.kakaoSignin()
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
    
    func sendSMSCode(phoneNumber: String, email: String?) -> RxSwift.Single<String> {
        authRepository.sendSMSCode(phoneNumber: phoneNumber, email: email)
    }
    
    func verifySMSCode(phoneNumber: String, code: String) -> RxSwift.Single<Bool> {
        authRepository.verifySMSCode(phoneNumber: phoneNumber, code: code)
    }
}
