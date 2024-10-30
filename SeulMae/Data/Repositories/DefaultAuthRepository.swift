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
    
    func signin(account: String, password: String, fcmToken: String?) -> Single<Credentials> {
        return network.rx
            .request(.signin(accountId: account, password: password, fcmToken: fcmToken))
            .map(BaseResponseDTO<CredentialsDto>.self)
            .map { try $0.toDomain() }
    }
    
    func socialSignin(type: SocialSigninType, token: String, fcmToken: String?) -> Single<Credentials> {
        return network.rx
            .request(.socialLogin(type: type.provider, token: token, fcmToken: nil))
            .map(BaseResponseDTO<CredentialsDto>.self)
            .map { try $0.toDomain() }
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
    
    func sendSMSCode(type: String, name: String, phoneNumber: String) -> RxSwift.Single<Bool> {
        return network.rx
            .request(.sendSMSCode(type: type, name: name, phoneNumber: phoneNumber))
            .map(Bool.self, atKeyPath: "data.isSuccess")
    }
    
    func verifySMSCode(phoneNumber: String, code: String) -> Single<Bool> {
        Swift.print(#function, "SMS Verification Code: \(code)")
        return network.rx
            .request(.verifySMSCode(phoneNumber: phoneNumber, code: code, item: .idRecovery))
            .do(onSuccess: { response in
                Swift.print("response: \(try response.mapString())")
            }, onError: { error in
                Swift.print("error: \(error)")
            })
            .map(BaseResponseDTO<String?>.self)
            .map { $0.isSuccess }
    }
    
    func supplementProfileInfo(
        profileInfoDTO: SupplementaryProfileInfoDTO,
        userImageData: Data) -> Single<Bool> {
            return network.rx
                .request(.supplementProfileInfo(request: profileInfoDTO, file: userImageData))
                .map(BaseResponseDTO<String>.self)
                .map { $0.isSuccess }
            
        }
}
