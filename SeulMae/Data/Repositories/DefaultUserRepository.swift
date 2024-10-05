//
//  DefaultUserRepository.swift
//  SeulMae
//
//  Created by 조기열 on 9/6/24.
//

import Foundation
import Moya
import RxSwift

final class UserRepository {
    
    // MARK: - Dependancies
    
    private let network: UserNetworking
    
    // MARK: - Life Cycle Methods
    
    init(network: UserNetworking) {
        self.network = network
    }
    
    var currentWorkplaceId: Workplace.ID {
        return 8
        // return UserDefaults.standard.integer(forKey: "currentWorkplaceId")
    }
    
    var fcmToken: String {
        return UserDefaults.standard.string(forKey: "fcm-token") ?? ""
    }
    
    func saveToken(_ token: Token) {
        UserDefaults.standard.setValue(token.accessToken, forKey: "accessToken")
        UserDefaults.standard.setValue(token.refreshToken, forKey: "refreshToken")
    }
    
    func readDefaultWorkplaceId() -> Int {
        // TODO: - 0이 반환될 경우 처리
        let defaultWorkplaceId = UserDefaults.standard.integer(forKey: "default-workplace-id")
        if defaultWorkplaceId == 0 {
            return 8
        } else {
            return defaultWorkplaceId
        }
    }
    
    func fetchMyProfile() -> RxSwift.Single<User> {
        return network.rx
            .request(.fetchMyProfile)
            .do(onSuccess: { response in
                Swift.print("response: \(try response.mapString())")
            }, onError: { error in
                Swift.print("error: \(error)")
            })
            .map(BaseResponseDTO<UserDTO>.self)
            .map { try $0.toDomain() }
    }
}
