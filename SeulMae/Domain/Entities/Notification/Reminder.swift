//
//  Notification.swift
//  SeulMae
//
//  Created by 조기열 on 9/14/24.
//

import Foundation

struct Reminder: Hashable, Identifiable {
    let id: Int
    let title: String
    let message: String
    let type: AppNotificationType
    let regDate: Date
}

enum AppNotificationType: String, Codable {
    // 시스템(플랫폼에서 전달하는 정보, 계정 활동 알림, 보안 경고, 업데이트 알림 등)
    case system = "SYSTEM"
    
    // 출퇴근 승인요청(알바생이 매니저에게 출퇴근 승일 요청)
    case attendanceRequest = "ATTENDANCE_REQUEST"
    
    // 출퇴근 승인여부 결과(알바생에게 매니저가 승인/거절한 내역을 전달하는 알림)
    case attendanceResponse = "ATTENDANCE_RESPONSE"
    
    // 근무지 가입 승인요청(근무지 입장 승인 요청)
    case joinRequset = "JOIN_REQUEST"
    
    // 근무지 가입여부 결과(근무지 가입여부 결과를 알림)
    case joinResponse = "JOIN_RESPONSE"
    
    // 공지사항(근무지 전체 공지사항 알림)
    case notice = "NOTICE"
    
    // 이벤트(사용자가 설정한 일정이나 이벤트의 시작 시간을 알리는 알림, 출근시간인 경우, 알바생에게 월급을 지급해야 하는 경우 등)
    case event = "EVENT"

    var category: String {
        switch self {
        case .attendanceResponse, .attendanceRequest: return "가입"
        case .joinResponse, .joinRequset: return "승인"
        default: return ""
        }
    }
}


