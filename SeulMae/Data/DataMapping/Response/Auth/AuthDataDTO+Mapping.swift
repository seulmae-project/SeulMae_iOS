//
//  AuthDataDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation
struct TokenDTO: ModelType {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
}

struct AuthDataDTO: ModelType {
    
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

extension TokenDTO {
    func toDomain() -> Token {
        return Token(
            accessToken: accessToken,
            refreshToken: refreshToken,
            tokenType: tokenType
        )
    }   
}
