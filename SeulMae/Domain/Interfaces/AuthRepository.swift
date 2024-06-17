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
    func signin(_ email: String, _ password: String) -> Single<Bool>
    func kakaoSignin() -> Single<Bool>
    
    /// - Tag: Signup
    func emailVerification(_ authCode: String) -> Single<Bool>
    func signup(_ request: SignupRequest) -> Single<Bool>
    
    /// - Tag: Account Recovery
    func recoveryEmail(_ phoneNumber: String) -> Single<Bool>
    func recoveryPassword(_ phoneNumber: String, _ newPassword: String) -> Single<Bool>
    
    /// - Tag: Common
    func phoneVerification(_ phoneNumber: String, _ email: String?) -> Single<Bool>
    func authCodeVerification(_ authCode: String) -> Single<Bool>
}
