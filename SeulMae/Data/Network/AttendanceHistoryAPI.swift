//
//  AttendanceAPI.swift
//  SeulMae
//
//  Created by 조기열 on 9/9/24.
//

import Foundation
import Moya

typealias AttendanceHistoryNetworking = MoyaProvider<AttendanceHistoryAPI>

enum AttendanceHistoryAPI: SugarTargetType {
    case fetchAttendanceCalendar(workplaceId: Workplace.ID, year: Int, month: Int)
    case fetchWorkeInfo(workplaceId: Workplace.ID)
    case fetchMonthlyAttendanceSummery(workplaceId: Workplace.ID, year: Int, month: Int)
    case fetchAttendanceHistories(workplaceId: Workplace.ID, year: Int, month: Int, page: Int, size: Int)
    case fetchAttendanceHistoryDetails(attendanceHistoryId: AttendanceHistory.ID)
    case updateAttendanceHistory(attendanceHistoryId: AttendanceHistory.ID)
}

extension AttendanceHistoryAPI {
    var baseURL: URL {
        return URL(string: Bundle.main.baseURL)!
    }
    
    var route: Route {
        switch self {
        case .fetchAttendanceCalendar:
            return .get("api/attendance/request-history/calender")
        case .fetchWorkeInfo:
            return .get("api/attendance/request-history/status")
        case .fetchMonthlyAttendanceSummery:
            return .get("api/attendance/request-history/monthly")
        case .fetchAttendanceHistories:
            return .get("api/attendance/request-history/list")
        case .fetchAttendanceHistoryDetails:
            return .get("api/attendance/request-history/detail")
        case .updateAttendanceHistory:
            return .get("api/attendance/request-history/detail-user")
        }
    }
    
    var task: Task {
        switch self {
        case let .fetchAttendanceCalendar(workplaceId: workplaceId, year: year, month: month):
            return .requestParameters(
                parameters: [
                    "workplaceId": workplaceId,
                    "year": year,
                    "month": month
                ],
                encoding: URLEncoding.queryString)
        case let .fetchWorkeInfo(workplaceId: workplaceId):
            return .requestParameters(
                parameters: [
                        "workplaceId": workplaceId,
                    ],
                encoding: URLEncoding.queryString)
        case let .fetchMonthlyAttendanceSummery(workplaceId: workplaceId, year: year, month: month):
            return .requestParameters(
                parameters: [
                        "workplaceId": workplaceId,
                        "year": year,
                        "month": month
                    ],
                encoding: URLEncoding.queryString)
        case let .fetchAttendanceHistories(workplaceId: workplaceId, year: year, month: month, page: page, size: size):
            return .requestParameters(
                parameters: [
                        "workplaceId": workplaceId,
                        "year": year,
                        "month": month,
                        "page": page,
                        "size": size
                    ],
                encoding: URLEncoding.queryString)
        case let .fetchAttendanceHistoryDetails(attendanceHistoryId: attendanceHistoryId):
            return .requestParameters(
                parameters: [
                    "idAttendanceRequestHistory": attendanceHistoryId
                ],
                encoding: URLEncoding.queryString)
        case let .updateAttendanceHistory(attendanceHistoryId: attendanceHistoryId):
            return .requestParameters(parameters: [
                "idAttendanceRequestHistory": attendanceHistoryId
            ], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            let accessToken = UserDefaults.standard.string(forKey: "accessToken")
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken!)"
            ]
        }
    }
}
