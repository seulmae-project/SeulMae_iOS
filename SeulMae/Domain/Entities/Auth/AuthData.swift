//
//  AuthData.swift
//  SeulMae
//
//  Created by 조기열 on 8/6/24.
//

import Foundation

struct AuthData {
    
    let token: Token
    let role: String
    let workplace: [Workplace]
}

//{
//    "tokenResponse": {
//      "accessToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJBY2Nlc3NUb2tlbiIsImFjY291bnRJZCI6IjAwMDI3Ni5kYTg1ODY5YTViZjk0YmZmODIwYzcxNjI4ZWNiZTdhZS4wMTAxIiwiZXhwIjoxNzI0MDU1MTY0fQ.V01_IKoOyN4j4fMoc0qUjk66QSBLqMpBUUO0vzDz4Tle0mvZ9sOVNMdOJopfpC957lp2VEmQTltuqUiExLZcJw",
//      "refreshToken": null,
//      "tokenType": "Bearer "
//    },
//    "role": "GUEST",
//    "workplaceResponses": []
//  },

