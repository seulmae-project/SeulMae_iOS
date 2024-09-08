//
//  SettingItem.swift
//  SeulMae
//
//  Created by 조기열 on 9/6/24.
//

import Foundation

struct SettingItem {
    let username: String
    let phoneNumber: String
    let birthday: String
    let imageURL: String
    // let version: String
    
    init(user: User) {
        self.username = user.name
        self.phoneNumber = user.phoneNumber
        self.birthday = "" // user.birthday
        self.imageURL = user.imageURL
    }
}
