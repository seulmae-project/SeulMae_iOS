//
//  AppDIContainer.swift
//  SeulMae
//
//  Created by 조기열 on 6/18/24.
//

import Foundation

final class AppDIContainer {

    func makeAuthSceneDIContainer() -> AuthSceneDIContainer {
        let dependencies = AuthSceneDIContainer.Dependencies(authNetworking: AuthNetworking())
        return AuthSceneDIContainer(dependencies: dependencies)
    }
    
    func makeMainSceneDIContainer() -> MainSceneDIContainer {
        let dependencies = MainSceneDIContainer.Dependencies(notificationNetworking: NotificationNetworking())
        return MainSceneDIContainer(dependencies: dependencies)
    }
    
    func makeHomeSceneDIContainer() -> HomeSceneDIContainer {
        let dependencies = HomeSceneDIContainer.Dependencies()
        return HomeSceneDIContainer(dependencies: dependencies)
    }
    
    func makeWorkplaceSceneDIContainer() -> WorkplaceSceneDIContainer {
        let dependencies = WorkplaceSceneDIContainer.Dependencies(
            workScheduleNetworking: WorkScheduleNetworking(),
            mainNetworking: AnnounceNetworking(),
            memberNetworking: UserNetworking())
        return WorkplaceSceneDIContainer(dependencies: dependencies)
    }
    
    func makeSettingSceneDIContainer() -> SettingSceneDIContainer {
        let dependencies = SettingSceneDIContainer.Dependencies(
            userNetworking: UserNetworking())
        return SettingSceneDIContainer(dependencies: dependencies)
    }
}
