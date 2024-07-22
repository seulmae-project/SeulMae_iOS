//
//  SignupRequest.swift
//  SeulMae
//
//  Created by 조기열 on 6/14/24.
//

import Foundation

struct SignupRequest {
    var email: String = ""
    var password: String = ""
    var phoneNumber: String = ""
    var name: String = ""
    var imageData: Data = Data()
    var isMale: Bool = false
    var birthday: String = "" // "19930815"
    
    mutating func setProfile(name: String, imageData: Data, isMale: Bool, birthday: String) {
        self.name = name
        self.imageData = imageData
        self.isMale = isMale
        self.birthday = birthday
    }
}
