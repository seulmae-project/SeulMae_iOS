//
//  AuthData.swift
//  SeulMae
//
//  Created by 조기열 on 8/6/24.
//

import Foundation

struct AuthData {
    struct Token {
        let accessToken: String
        let refreshToken: String
        let tokenType: String
    }
    
    let token: Token
    let role: String
    let workplace: [Workplace]
}
