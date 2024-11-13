//
//  AppDIContainer.swift
//  SeulMae
//
//  Created by 조기열 on 6/18/24.
//

import Foundation

final class AppDIContainer {
    
    let loggerPlugin = CustomNetworkLoggerPlugin()
    lazy var authNetworking = AuthNetworking(plugins: [loggerPlugin])
    lazy var notificationNetworking = NotificationNetworking(plugins: [loggerPlugin])
    lazy var workplaceNetworking = WorkplaceNetworking(plugins: [loggerPlugin])
    lazy var attendanceNetworking = AttendanceNetworking(plugins: [loggerPlugin])
    lazy var workScheduleNetworking = WorkScheduleNetworking(plugins: [loggerPlugin])
    lazy var announceNetworking = AnnounceNetworking(plugins: [loggerPlugin])
    lazy var userNetworking = UserNetworking(plugins: [loggerPlugin])
    lazy var attendanceHistoryNetworking = AttendanceHistoryNetworking(plugins: [loggerPlugin])

    func makeAuthSceneDIContainer() -> AuthSceneDIContainer {
        return .init(
            dependencies: .init(
                authNetworking: authNetworking,
                userNetworking: userNetworking
            )
        )
    }
    
    func makeTabBarSceneDIContainer() -> TabBarSceneDIContainer {
        return .init(
            dependencies: .init(
                notificationNetworking: notificationNetworking,
                workplaceNetworking: workplaceNetworking,
                attendanceNetworking: attendanceNetworking
            ))
    }

    func makeFinderSceneDIContainer() -> FinderSceneDIContainer {
        return .init(
            dependencies: .init(
                notificationNetworking: notificationNetworking,
                workplaceNetworking: workplaceNetworking,
                attendanceNetworking: attendanceNetworking
            ))
    }

    func makeHomeSceneDIContainer() -> HomeSceneDIContainer {
        return .init(
            dependencies: .init(
                attendanceNetworking: attendanceNetworking,
                workplaceNetworking: workplaceNetworking,
                notificationNetworking: notificationNetworking, 
                attendanceHistoryNetworking: attendanceHistoryNetworking,
                workScheduleNetworking: workScheduleNetworking
            ))
    }
    
    func makeWorkplaceSceneDIContainer() -> WorkplaceSceneDIContainer {
        return .init(
            dependencies: .init(
                workScheduleNetworking: workScheduleNetworking,
                announceNetworking: announceNetworking,
                memberNetworking: userNetworking
            ))
    }
    
    func makeSettingSceneDIContainer() -> SettingSceneDIContainer {
        return .init(
            dependencies: .init(
                userNetworking: userNetworking
            ))
    }

    func makeCommonSceneDIContainer() -> CommonSceneDIContainer {
        return .init(
            dependencies: .init(
                notificationNetworking: notificationNetworking
            ))
    }
}
