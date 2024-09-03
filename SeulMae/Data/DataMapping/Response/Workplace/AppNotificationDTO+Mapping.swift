//
//  AppNotificationDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 8/20/24.
//

import Foundation

struct AppNotificationDTO: ModelType {
    let id: Int
    let title: String?
    let message: String?
    let type: String?
    let regDate: Date?
    
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
        return data.map { $0.toDomain() }
    }
}

extension AppNotificationDTO {
    func toDomain() -> AppNotification {
        return .init(
            id: id,
            title: title ?? "",
            message: message ?? "",
            type: type ?? "",
            regDate: regDate ?? Date()
        )
    }
}
