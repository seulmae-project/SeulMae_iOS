//
//  SigninDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation

struct SigninDTO: ModelType {
    struct TokenDTO: ModelType {
        let accessToken: String?
        let refreshToken: String?
        let tokenType: String?
    }
    
    let tokenResponse: TokenDTO?
    let role: String?
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<SigninDTO> {
    func toDomain() -> Token? {
        data?.tokenResponse?.toDomain()
    }
}

extension SigninDTO.TokenDTO {
    func toDomain() -> Token {
        return Token(
            accessToken: accessToken ?? "",
            refreshToken: refreshToken ?? "",
            tokenType: tokenType ?? ""
        )
    }
}
