//
//  DefaultAuthRepository.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Moya
import RxMoya
import RxSwift

class DefaultAuthRepository: AuthRepository {
   
    // MARK: - Dependancies
    
    private let network: AuthNetworking
    
    // MARK: - Life Cycle Methods
    
    init(network: AuthNetworking) {
        self.network = network
    }
    
    // MARK: - Signin
    
    func signin(_ email: String, _ password: String) -> Single<Token> {
        return Single<BaseResponseDTO<AuthDataDTO>>.create { observer in
            if email == "yonggipo@icloud.com" && password == "a*123456" {
                observer(.success(signinResponse_success))
            } else {
                observer(.success(signinResponse_failed))
            }
            
            return Disposables.create()
        }
        .map { try $0.toDomain() }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    func kakaoSignin() -> Single<Bool> {
        return Single<Bool>.create { observer in
            observer(.success(true))
            return Disposables.create()
        }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    // MARK: - Signup
    
    func userIDAvailable(_ userID: String) -> Single<Bool> {
        Swift.print(#fileID, #function, "\n-userID: \(userID)\n -testUserID: yonggipo\n")
        return Single<BaseResponseDTO<Bool>>.create { observer in
            if userID == "yonggipo" {
                observer(.success(emailValidationResponse_true))
            } else {
                observer(.success(emailValidationResponse_false))
            }
            return Disposables.create()
        }
        .map { $0.isSuccess }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    func signup(_ request: SignupRequest) -> Single<Bool> {
        return Single<BaseResponseDTO<String>>.create { observer in
            observer(.success(signupResponse_success))
            return Disposables.create()
        }
        .map { $0.isSuccess }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    // MARK: - Account Recovery
    
    func recoveryEmail(_ phoneNumber: String) -> Single<Bool> {
        return .just(.random())
    }
    
    func recoveryPassword(_ phoneNumber: String, _ newPassword: String) -> Single<Bool> {
        return Single<BaseResponseDTO<String>>.create { observer in
            if newPassword == "a*123456" {
                observer(.success(passwordRecoveryResponse_failed))
            } else {
                observer(.success(passwordRecoveryResponse_success))
            }
            return Disposables.create()
        }
        .map { $0.isSuccess }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    // MARK: - Common
    
    func phoneVerification(_ phoneNumber: String, _ email: String?) -> Single<Bool> {
        Swift.print(#fileID, #function, "\n-phoneNumber: \(phoneNumber),\n-email: \(email ?? "")\n")
        return Single<BaseResponseDTO<EmailDTO>>.create { observer in
            observer(.success(requestSmsCertificationResponse_success))
            return Disposables.create()
        }
        .map { $0.isSuccess }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    func authCodeVerification(_ authCode: String) -> Single<Bool> {
        Swift.print(#fileID, #function, "\n-authCode: \(authCode)\n -testCode: 123456\n")
        return Single<BaseResponseDTO<String>>.create { observer in
            if authCode == "123456" {
                observer(.success(authCodeCertificationResponse_success))
            } else {
                observer(.failure(DomainError.failedToSMSVerification))
            }
            return Disposables.create()
        }
        .map { $0.isSuccess }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
}
