//
//  AppNotificationDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 8/20/24.
//

import Foundation

struct AppNotificationDTO: ModelType {
    let id: Int // notificationId
    let title: String
    let message: String
    let type: NotificationType // notificationType
    let regDate: Date // regDateNotification 2024-07-23T19:24:46.025958
    
    enum CodingKeys: String, CodingKey {
        case id = "notificationId"
        case title
        case message
        case type = "notificationType"
        case regDate = "regDateNotification"
    }
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<[AppNotificationDTO]> {
    func toDomain() -> [AppNotification] {
        return data?.map { $0.toDomain() } ?? []
    }
}

extension AppNotificationDTO {
    func toDomain() -> AppNotification {
        return .init(
            id: self.id,
            title: self.title,
            message: self.message,
            type: self.type,
            regDate: self.regDate
        )
    }
}
