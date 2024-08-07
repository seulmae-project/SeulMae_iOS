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
    
    func signin(account: String, password: String, fcmToken: String) -> Single<AuthData> {
        return network.rx
            .request(.signin(accountID: account, password: password, fcmToken: fcmToken))
            .map(BaseResponseDTO<AuthDataDTO>.self)
            .map { try $0.toDomain() }
            .do(onSuccess: { response in
                Swift.print("response: \(response)")
            }, onError: { error in
                Swift.print("error: \(error)")
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
    
    func verifyAccountID(_ accountID: String) -> Single<Bool> {
        return network.rx.request(.verifyAccountID(accountID))
            .map(Bool.self, atKeyPath: "data.duplicated")
            .do(onSuccess: { response in
                Swift.print("response: \(response)")
            }, onError: { error in
                Swift.print("error: \(error)")
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
    
    func sendSMSCode(phoneNumber: String, email: String?) -> Single<String> {
        Swift.print(#function, "Send SMS Code: \(phoneNumber), \(email ?? "nil")")
        return network.rx
            .request(.sendSMSCode(phoneNumber: phoneNumber, email: email))
            .map(String?.self, atKeyPath: "data.accountId")
            .map { $0 ?? "nil" }
            .do(onSuccess: { response in
                Swift.print("response: \(response)")
            }, onError: { error in
                Swift.print("error: \(error)")
            })
    }
    
    func verifySMSCode(phoneNumber: String, code: String) -> Single<Bool> {
        Swift.print(#function, "SMS Verification Code: \(code)")
        return network.rx
            .request(.verifySMSCode(phoneNumber: phoneNumber, code: code))
            .map(BaseResponseDTO<String?>.self)
            .map { $0.isSuccess }
            .do(onSuccess: { response in
                Swift.print("response: \(response)")
            }, onError: { error in
                Swift.print("error: \(error)")
            })
    }
}
