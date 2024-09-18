//
//  DefaultAuthRepository.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import struct Foundation.Data
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
            .request(.signin(accountId: account, password: password, fcmToken: fcmToken))
            .do(onSuccess: { response in
                Swift.print("response: \(try response.mapString())")
            }, onError: { error in
                Swift.print("error: \(error)")
            })
            .map(BaseResponseDTO<AuthDataDTO>.self)
            .map { try $0.toDomain() }
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
        return network.rx.request(.verifyAccountId(accountID))
            .do(onSuccess: { response in
                Swift.print("response: \(try response.mapString())")
            }, onError: { error in
                Swift.print("error: \(error)")
            })
            .map(Bool.self, atKeyPath: "data.duplicated")
    }
    
    func signup(request: SignupRequest, file: Data) -> Single<Bool> {
        return network.rx
            .request(.signup(request: request, file: file))
            .do(onSuccess: { response in
                Swift.print("response: \(try response.mapString())")
            }, onError: { error in
                Swift.print("error: \(error)")
            })
            .map(BaseResponseDTO<String?>.self)
            .map { $0.isSuccess }
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
            .request(.sendSMSCode(phoneNumber: phoneNumber, item: .accountRecovery))
            .do(onSuccess: { response in
                Swift.print("response: \(try response.mapString())")
            }, onError: { error in
                Swift.print("error: \(error)")
            })
            .map(String?.self, atKeyPath: "data.accountId")
            .map { $0 ?? "nil" }
    }
    
    func verifySMSCode(phoneNumber: String, code: String) -> Single<Bool> {
        Swift.print(#function, "SMS Verification Code: \(code)")
        return network.rx
            .request(.verifySMSCode(phoneNumber: phoneNumber, code: code, item: .accountRecovery))
            .do(onSuccess: { response in
                Swift.print("response: \(try response.mapString())")
            }, onError: { error in
                Swift.print("error: \(error)")
            })
            .map(BaseResponseDTO<String?>.self)
            .map { $0.isSuccess }
    }
}
