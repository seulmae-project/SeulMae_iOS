//
//  TokenStorage.swift
//  SeulMae
//
//  Created by 조기열 on 8/19/24.
//

import Foundation

struct Token {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
}

protocol TokenStorage {
    func fetchToken() -> Token
}
