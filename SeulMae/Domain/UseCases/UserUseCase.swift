//
//  UserUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 9/6/24.
//

import Foundation
import RxSwift

protocol UserUseCase {
    func fetchMyProfile() -> RxSwift.Single<User>
    //

    var currentWorkplaceId: Int { get }

}

final class DefaultUserUseCase: UserUseCase {
    
    private var userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    var currentWorkplaceId: Workplace.ID {
        UserDefaults.standard.integer(forKey: "defaultWorkplace")
    }

    func fetchMyProfile() -> RxSwift.Single<User> {
        return userRepository.fetchMyProfile()
    }
}

struct UserDTO: Codable {
    let name: String?
    let imageURL: String?
    let phoneNumber: String?
    let workplaces: [WorkplaceDTO]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageURL = "userImageURL"
        case phoneNumber
        case workplaces = "userWorkplaceInfoResponses"
    }
    
//    {
//          "userWorkScheduleId": 1,
//          "userId": 1,
//          "userName": "테스트",
//          "userImageURL": null
//        }
}

struct User {
    let name: String
    let imageURL: String
    let phoneNumber: String
    let workplaces: [Workplace]
}

extension BaseResponseDTO<UserDTO> {
    func toDomain() throws -> User {
        return data!.toDomain()
    }
}

extension BaseResponseDTO<[UserDTO]> {
    func toDomain() -> [User] {
        return data?.map { $0.toDomain() } ?? []
    }
}

extension UserDTO {
    func toDomain() -> User {
        return .init(
            name: self.name ?? "",
            imageURL: self.imageURL ?? "",
            phoneNumber: self.phoneNumber ?? "",
            workplaces: self.workplaces?.map { $0.toDomain() } ?? []
        )
    }
}
