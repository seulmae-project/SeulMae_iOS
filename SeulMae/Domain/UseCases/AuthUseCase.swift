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
    func signin(accountId: String, password: String) -> Single<Bool>
    func socialSignin(type: SocialSigninType, token: String) -> Single<(Bool, Bool)>
    
    // Signup
    func verifyAccountID(_ accountID: String) -> Single<Bool>
    func signup(request: SignupRequest, file: Data) -> Single<Bool>
    
    // Credential Recovery
    func recoveryEmail(_ phoneNumber: String) -> Single<Bool>
    func recoveryPassword(_ phoneNumber: String, _ newPassword: String) -> Single<Bool>
    
    // Common
    func sendSMSCode(type: String, phoneNumber: String, accountId: String?) -> Single<Bool>
    func verifySMSCode(phoneNumber: String, code: String) -> Single<Bool>
    
    func setupProfile(request: SupplementaryProfileInfoDTO, file: Data) -> Single<Bool> // in case social login
}

class DefaultAuthUseCase: AuthUseCase {
    
    private let authRepository: AuthRepository
    private let workplaceRepository: WorkplaceRepository
    private let userRepository: UserRepository = UserRepository(network: UserNetworking())
    
    init(authRepository: AuthRepository, workplaceRepository: WorkplaceRepository) {
        self.authRepository = authRepository
        self.workplaceRepository = workplaceRepository
    }
        
    func signin(accountId: String, password: String) -> RxSwift.Single<Bool> {
        let fcmToken = ""
        return authRepository.signin(account: accountId, password: password, fcmToken: fcmToken)
            .map { [weak self] response in
                guard let strongSelf = self else { return false }
                // save workplace list
                let isSaved = strongSelf.workplaceRepository
                    .create(workplaceList: response.workplace, accountId: accountId)
                // save acount id
                UserDefaults.standard.setValue(accountId, forKey: "accountId")
                // save tokens
                self?.userRepository.saveToken(response.token)
                return isSaved
            }
    }
    
    enum SocialSigninRole: String {
        case guest = "GUEST"
        case user = "USER"
        
        var isGuest: Bool {
            return (self == .guest)
        }
    }
    
    func socialSignin(type: SocialSigninType, token: String) -> RxSwift.Single<(Bool, Bool)> {
        let fcmToken = userRepository.fcmToken
        return authRepository.socialSignin(type: type, token: token, fcmToken: fcmToken)
            .map { [weak self] credential in
                self?.userRepository.saveToken(credential.token)
                _ = self?.workplaceRepository.create(
                    workplaceList: credential.workplace,
                    accountId: type.provider)
                let isGuest = (credential.role == "GUEST")
                let hasGroup = !credential.workplace.isEmpty
                return (isGuest, hasGroup)
            }
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
    
    func setupProfile(request: SupplementaryProfileInfoDTO, file: Data) -> Single<Bool> {
        return authRepository.supplementProfileInfo(profileInfoDTO: request, userImageData: file)
    }
}
