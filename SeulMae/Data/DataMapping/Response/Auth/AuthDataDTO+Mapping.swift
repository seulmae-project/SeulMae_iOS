//
//  AuthDataDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation

struct AuthDataDTO: ModelType {
    struct TokenDTO: ModelType {
        let accessToken: String
        let refreshToken: String
        let tokenType: String
    }
    
    let token: TokenDTO
    let role: String?
    let workplace: [WorkplaceDTO]
    
    enum CodingKeys: String, CodingKey {
        case token = "tokenResponse"
        case role
        case workplace = "workplaceResponses"
    }
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<AuthDataDTO> {
    func toDomain() throws -> AuthData {
        guard let data else {
            throw MappingError.emptyData(Data.self)
        }
        
        return try data.toDomain()
    }
}

extension AuthDataDTO {
    func toDomain() throws -> AuthData {
        
        return AuthData(
            token: token.toDomain(),
            role: role ?? "",
            workplace: workplace.map { try! $0.toDomain() }
        )
    }
}

extension AuthDataDTO.TokenDTO {
    func toDomain() -> AuthData.Token {
        return AuthData.Token(
            accessToken: accessToken,
            refreshToken: refreshToken,
            tokenType: tokenType
        )
    }   
}
