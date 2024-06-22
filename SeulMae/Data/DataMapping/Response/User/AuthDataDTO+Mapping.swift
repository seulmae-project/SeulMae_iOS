//
//  AuthDataDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation

struct AuthDataDTO: ModelType {
    struct TokenDTO: ModelType {
        let accessToken: String?
        let refreshToken: String?
        let tokenType: String?
    }
    
    let tokenResponse: TokenDTO?
    let role: String?
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<AuthDataDTO> {
    func toDomain() throws -> Token {
        guard let token = data?.tokenResponse else {
            if let reason {
                throw DomainError.faildedToSignin(reason)
            }
            
            let keyPath = String(describing: \AuthDataDTO.tokenResponse)
            throw DomainError.empty(keyPath)
        }
        
        return try token.toDomain()
    }
}

extension AuthDataDTO.TokenDTO {
    func toDomain() throws -> Token {
        guard let accessToken else {
            let keyPath = NSExpression(forKeyPath: \AuthDataDTO.TokenDTO.accessToken).keyPath
            throw DomainError.empty(keyPath)
        }
        return Token(
            accessToken: accessToken,
            refreshToken: refreshToken ?? "",
            tokenType: tokenType ?? ""
        )
    }
}
