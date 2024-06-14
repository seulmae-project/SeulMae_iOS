//
//  SignupRequest.swift
//  SeulMae
//
//  Created by 조기열 on 6/14/24.
//

import Foundation

struct SignupRequest {
    let email: String
    let password: String
    let phoneNumber: String
    let name: String
    let imageURL: String
    let isMale: Bool
    let birthday: Date // "19930815"
}
