//
//  AttendnaceAPI.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import Foundation
import Moya

typealias AttendanceNetworking = MoyaProvider<AttendnaceAPI>
// 추후 attendnaceAPI
enum AttendnaceAPI: SugarTargetType {
    case attend(request: AttendRequest)  // 출퇴근 승인 요청
    case approveAttendance(request: ApproveAttendanceRequest) // 출퇴근 승인 요청 승인
    case disapproveAttendance(attendanceHistoryId: AttendanceHistory.ID) // 거절
    case fetchAttendanceRequsetList(workplaceId: Workplace.ID) // 응답하지 않은 요청
    case attend2(request: AttendRequest) // 출퇴근 별도 근무 요청
    case fetchAttendanceRequsetList2(workplaceId: Workplace.ID, date: Date) // 모든 요청 리스트
}

extension AttendnaceAPI {
    var baseURL: URL {
        return URL(string: Bundle.main.baseURL)!
    }
    
    var route: Route {
        switch self {
        case .attend: return .post("api/attendance/v1/finish")
        case .approveAttendance: return .post("api/attendance/v1/manager/approval")
        case .disapproveAttendance: return .post("api/attendance/v1/manager/rejection")
        case .fetchAttendanceRequsetList: return .get("api/attendance/v1/request/list")
        case .attend2: return .post("api/attendance/v1/separate")
        case .fetchAttendanceRequsetList2: return .get("api/attendance/v1/main/manager")
        }
    }
    
    var task: Task {
        switch self {
        case let .attend(request: request):
            return .requestJSONEncodable(request)
        case let .approveAttendance(request: request):
            return .requestJSONEncodable(request)
        case let .disapproveAttendance(attendanceHistoryId: attendanceHistoryId):
            return .requestParameters(
                parameters: [
                    "attendanceRequestHistoryId": attendanceHistoryId,
                ], encoding: URLEncoding.queryString)
        case let .fetchAttendanceRequsetList(workplaceId: workplaceId):
            return .requestParameters(
                parameters: [
                    "workplaceId": workplaceId,
                ], encoding: URLEncoding.queryString)
        case let .attend2(request: request):
            return .requestJSONEncodable(request)
        case let .fetchAttendanceRequsetList2(workplaceId: workplaceId, date: date):
            // TODO: - 
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let formatted = formatter.string(from: date)
            return .requestParameters(
                parameters: [
                    "workplace": workplaceId,
                    "localDate": formatted
                ],
                encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "accessToken")!)"
                //Authorization-refresh
            ]
        }
    }
}
