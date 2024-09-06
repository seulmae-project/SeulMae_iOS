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
}

final class DefaultUserUseCase: UserUseCase {
    private var userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func fetchMyProfile() -> RxSwift.Single<User> {
        return userRepository.fetchMyProfile()
    }
}

struct UserDTO: Codable {
    let name: String?
    let imageURL: String? // userImageURL
    let phoneNumber: String?
    let workplaces: [WorkplaceDTO]? // userWorkplaceInfoResponses
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageURL
        case phoneNumber
        case workplaces
    }
}

extension BaseResponseDTO<UserDTO> {
    func toDomain() throws -> User {
        return try getData().toDomain()
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

struct User {
    let name: String
    let imageURL: String
    let phoneNumber: String
    let workplaces: [Workplace]
}
