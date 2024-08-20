//
//  AppNotification.swift
//  SeulMae
//
//  Created by 조기열 on 8/20/24.
//

import Foundation

struct AppNotification: Identifiable {
    let id: Int
    let title: String
    let message: String
    let type: String
    let regDate: Date
}
