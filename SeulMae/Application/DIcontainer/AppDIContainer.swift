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
        let dependencies = MainSceneDIContainer.Dependencies(mainNetworking: MainNetworking())
        return MainSceneDIContainer(dependencies: dependencies)
    }
}
