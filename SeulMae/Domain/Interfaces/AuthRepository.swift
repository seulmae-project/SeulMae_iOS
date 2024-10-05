//
//  AuthRepository.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import Foundation
import RxSwift

protocol AuthRepository {
    func signin(account: String, password: String, fcmToken: String) -> Single<Credentials>
    func socialSignin(type: SocialSigninType, token: String, fcmToken: String?) -> Single<Credentials>
    func verifyAccountID(_ accountID: String) -> Single<Bool>
    func signup(request: SignupRequest, file: Data) -> Single<Bool>
    func recoveryEmail(_ phoneNumber: String) -> Single<Bool>
    func recoveryPassword(_ phoneNumber: String, _ newPassword: String) -> Single<Bool>
    func sendSMSCode(type: String, phoneNumber: String, accountId: String?) -> Single<Bool>
    func verifySMSCode(phoneNumber: String, code: String) -> Single<Bool>
    
    func supplementProfileInfo(profileInfoDTO: SupplementaryProfileInfoDTO, userImageData: Data) -> Single<Bool> // in case social login

    
//case signup(request: SignupRequest, file: Data)
//case sendSMSCode(type: String, phoneNumber: String, accountId: String?)
//case verifySMSCode(phoneNumber: String, code: String, item: SMSVerificationItem)
//case verifyAccountId(_ accountId: String)
//case signin(accountId: String, password: String, fcmToken: String)
//case socialLogin(type: String, token: String, fcmToken: String?)
//case signout
//case updatePassword(accountId: String, password: String)
//case updateProfile(userId: Member.ID, request: UpdateProfileRequest, file: Data)
//case cancelAccoount(userId: Member.ID)
    
//case updatePhoneNumber(userId: Member.ID, phoneNumber: String)
}
