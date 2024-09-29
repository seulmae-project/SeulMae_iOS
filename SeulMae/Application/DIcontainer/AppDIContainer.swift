//
//  AppDIContainer.swift
//  SeulMae
//
//  Created by 조기열 on 6/18/24.
//

import Foundation

final class AppDIContainer {

    func makeAuthSceneDIContainer() -> AuthSceneDIContainer {
        let dependencies = AuthSceneDIContainer.Dependencies(
            authNetworking: AuthNetworking(
                session: .custom,
                plugins: [CustomNetworkLoggerPlugin()]))
        return AuthSceneDIContainer(dependencies: dependencies)
    }
    
    func makeMainSceneDIContainer() -> MainSceneDIContainer {
        let dependencies = MainSceneDIContainer.Dependencies(
            notificationNetworking: NotificationNetworking(
                plugins: [CustomNetworkLoggerPlugin()]
            ),
            workplaceNetworking: WorkplaceNetworking(
                plugins: [CustomNetworkLoggerPlugin()]
            )
        )
        return MainSceneDIContainer(dependencies: dependencies)
    }
    
    func makeHomeSceneDIContainer() -> HomeSceneDIContainer {
        let dependencies = HomeSceneDIContainer.Dependencies()
        return HomeSceneDIContainer(dependencies: dependencies)
    }
    
    func makeWorkplaceSceneDIContainer() -> WorkplaceSceneDIContainer {
        let dependencies = WorkplaceSceneDIContainer.Dependencies(
            workScheduleNetworking: WorkScheduleNetworking(session: .custom, plugins: [CustomNetworkLoggerPlugin()]),
            mainNetworking: AnnounceNetworking(session: .custom, plugins: [CustomNetworkLoggerPlugin()]),
            memberNetworking: UserNetworking(session: .custom, plugins: [CustomNetworkLoggerPlugin()]))
        return WorkplaceSceneDIContainer(dependencies: dependencies)
    }
    
    func makeSettingSceneDIContainer() -> SettingSceneDIContainer {
        let dependencies = SettingSceneDIContainer.Dependencies(
            userNetworking: UserNetworking(session: .custom, plugins: [CustomNetworkLoggerPlugin()]))
        return SettingSceneDIContainer(dependencies: dependencies)
    }
}
