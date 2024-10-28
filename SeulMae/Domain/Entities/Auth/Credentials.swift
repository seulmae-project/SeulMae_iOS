//
//  Credentials.swift
//  SeulMae
//
//  Created by 조기열 on 8/6/24.
//

import Foundation

struct Credentials {
    let token: Token
    let role: String
    let workplace: [Workplace]

    var isGuest: Bool {
        role == "GUEST"
    }

    var defaultWorkplaceId: Int? {
        UserDefaults.standard.integer(forKey: "defaultWorkplace")
    }
}
