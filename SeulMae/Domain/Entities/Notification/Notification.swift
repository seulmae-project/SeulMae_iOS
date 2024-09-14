//
//  Notification.swift
//  SeulMae
//
//  Created by 조기열 on 9/14/24.
//

import Foundation

struct Notification: Identifiable {
    let id: Int // notificationId
    let title: String
    let message: String
    let type: NotificationType // notificationType
    let regDate: String // regDateNotification 2024-07-23T19:24:46.025958
}

struct NotificationDTO: ModelType {
    let id: Int // notificationId
    let title: String
    let message: String
    let type: NotificationType // notificationType
    let regDate: String // regDateNotification 2024-07-23T19:24:46.025958
    
    enum CodingKeys: String, CodingKey {
        case id = "notificationId"
        case title
        case message
        case type = "notificationType"
        case regDate = "regDateNotification"
    }
}

enum NotificationType: String, Codable {
//    SYSTEM("시스템", "플랫폼에서 전달하는 정보", "계정 활동 알림, 보안 경고, 업데이트 알림 등"),
//    ATTENDANCE_REQUEST("출퇴근 승인요청", "알바생이 매니저에게 출퇴근 승일 요청", null),
//    ATTENDANCE_RESPONSE("출퇴근 승인여부 결과", "알바생에게 매니저가 승인/거절한 내역을 전달하는 알림", null),
//    JOIN_REQUEST("근무지 가입 승인요청", "근무지 입장 승인 요청", null),
//    JOIN_RESPONSE("근무지 가입여부 결과", "근무지 가입여부 결과를 알림", null),
//    NOTICE("공지사항", "근무지 전체 공지사항 알림", null),
//    EVENT("이벤트", "사용자가 설정한 일정이나 이벤트의 시작 시간을 알리는 알림", "출근시간인 경우, 알바생에게 월급을 지급해야 하는 경우 등");
    
    case system
    case attendanceRequest
    case attendanceResponse
    case joinRequset
    case joinResponse
    case notice
    case event
}

extension NotificationType {
    
}

extension BaseResponseDTO<[NotificationDTO]> {
    func toDomain() -> [Notification] {
        return data?.map { $0.toDomain() } ?? []
    }
}

extension NotificationDTO {
    func toDomain() -> Notification {
        return .init(
            id: self.id,
            title: self.title,
            message: self.message,
            type: self.type,
            regDate: self.regDate
        )
    }
}
