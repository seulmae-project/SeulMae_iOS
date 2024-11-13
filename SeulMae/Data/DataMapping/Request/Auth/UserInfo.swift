//
//  UserInfo.swift
//  SeulMae
//
//  Created by 조기열 on 6/14/24.
//

import Foundation

struct UserInfo: ModelType {
    var accountId: String = ""
    var password: String = ""
    var phoneNumber: String = ""
    var name: String = ""
    var isMale: Bool = false
    var birthday: String = "" // "19930815"
    
    mutating func updatePhoneNumber(_ phoneNumber: String) {
        self.phoneNumber = phoneNumber
    }
    
    mutating func updateCredentials(account: String, password: String) {
        self.accountId = account
        self.password = password
    }
    
    mutating func updateProfile(name: String, isMale: Bool, birthday: String) {
        self.name = name
        self.isMale = isMale
        self.birthday = birthday
    }
}
