//
//  CredentialsDto+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation

struct TokenDto: ModelType {
    let accessToken: String
    let refreshToken: String?
    let tokenType: String
}

struct CredentialsDto: ModelType {
    let token: TokenDto
    let role: String?
    let workplace: [WorkplaceDTO]
    
    enum CodingKeys: String, CodingKey {
        case token = "tokenResponse"
        case role
        case workplace = "workplaceResponses"
    }
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<CredentialsDto> {
    func toDomain() -> Credentials {
        return data!.toDomain()
//        error = "Internal Server Error";
//        path = "/api/users/social-login";
//        status = 500;
//        timestamp = "2024-09-29T05:54:15.205+00:00";
    }
}

extension CredentialsDto {
    func toDomain() -> Credentials {
        return Credentials(
            token: token.toDomain(),
            role: role ?? "",
            workplace: workplace.map { $0.toDomain() }
        )
    }
}

extension TokenDto {
    func toDomain() -> Token {
        return Token(
            accessToken: accessToken,
            refreshToken: refreshToken ?? "",
            tokenType: tokenType
        )
    }   
}
