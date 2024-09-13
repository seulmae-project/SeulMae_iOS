//
//  AttendanceAPI.swift
//  SeulMae
//
//  Created by 조기열 on 9/9/24.
//

import Foundation
import Moya

typealias AttendanceNetworking = MoyaProvider<AttendanceAPI>

enum AttendanceAPI: SugarTargetType {
    case fetchAttendanceRequestList(workplaceId: Workplace.ID, year: Int, month: Int)
    case fetchAttendanceCalendar(workplaceId: Workplace.ID, year: Int, month: Int)
    case fetchWorkeInfo(workplaceId: Workplace.ID)
    case fetchMonthlyAttendanceSummery(workplaceId: Workplace.ID, year: Int, month: Int)
    case fetchAttendanceHistories(workplaceId: Workplace.ID, year: Int, month: Int, page: Int, size: Int)
    case fetchAttendanceHistoryDetails(attendanceHistoryId: AttendanceHistory.ID)
    case updateAttendanceHistory(attendanceHistoryId: AttendanceHistory.ID)
}

extension AttendanceAPI {
    var baseURL: URL {
        return URL(string: Bundle.main.baseURL)!
    }
    
    var route: Route {
        switch self {
        case .fetchAttendanceRequestList:
            return .get("api/attendance/request-history/calender")
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
    
    var parameters: Parameters? {
        switch self {
        case let .fetchAttendanceRequestList(workplaceId: workplaceId, year: year, month: month):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return [
                "workplaceId": workplaceId,
                "year": year,
                "month": month
            ]
        case let .fetchAttendanceCalendar(workplaceId: workplaceId, year: year, month: month):
            return [
                "workplaceId": workplaceId,
                "year": year,
                "month": month
            ]
        case let .fetchWorkeInfo(workplaceId: workplaceId):
            return ["workplaceId": workplaceId]
        case let .fetchMonthlyAttendanceSummery(workplaceId: workplaceId, year: year, month: month):
            return [
                "workplaceId": workplaceId,
                "year": year,
                "month": month
            ]
        case let .fetchAttendanceHistories(workplaceId: workplaceId, year: year, month: month, page: page, size: size):
            return [
                "workplaceId": workplaceId,
                "year": year,
                "month": month
            ]
        case let .fetchAttendanceHistoryDetails(attendanceHistoryId: attendanceHistoryId):
            return [
                "attendanceHistoryId": attendanceHistoryId
            ]
        case let .updateAttendanceHistory(attendanceHistoryId: attendanceHistoryId):
            return [
                "attendanceHistoryId": attendanceHistoryId
            ]
        }
    }
    
    var body: Encodable? {
        switch self {
        default:
            return nil
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
    
    var data: Data? {
        switch self {
        default:
            return nil
        }
    }
}
