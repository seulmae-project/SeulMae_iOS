//
//  AuthRepository.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import Foundation
import RxSwift

protocol AuthRepository {
    /// - Tag: Signin
    func signin(account: String, password: String, fcmToken: String) -> Single<AuthData>
    func kakaoSignin() -> Single<Bool>
    
    /// - Tag: Signup
    func userIDAvailable(_ authCode: String) -> Single<Bool>
    func signup(_ request: SignupRequest) -> Single<Bool>
    
    /// - Tag: Account Recovery
    func recoveryEmail(_ phoneNumber: String) -> Single<Bool>
    func recoveryPassword(_ phoneNumber: String, _ newPassword: String) -> Single<Bool>
    
    /// - Tag: Common
    func sendSMSCode(phoneNumber: String, email: String?) -> Single<String>
    func verifySMSCode(phoneNumber: String, code: String) -> Single<Bool>
}
