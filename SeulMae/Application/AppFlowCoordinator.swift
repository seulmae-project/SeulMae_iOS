//
//  AppFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 6/18/24.
//

import UIKit

class AppFlowCoordinator {
    
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let authSceneDIContainer = appDIContainer.makeAuthSceneDIContainer()
        var authCoordinator = authSceneDIContainer.makeAuthFlowCoordinator(navigationController: navigationController)
        let mainCoordinator = makeMainCoordinator()
        authCoordinator.coordinators.append(mainCoordinator)
        authCoordinator.start(nil)
    }
    
    func makeMainCoordinator() -> MainFlowCoordinator {
        let mainSceneDIContainer = appDIContainer.makeMainSceneDIContainer()
        var mainCoordinator = mainSceneDIContainer.makeMainFlowCoordinator(navigationController: navigationController)
        
        let homeSceneDIContainer = appDIContainer.makeHomeSceneDIContainer()
        let homeCoordinator = homeSceneDIContainer.makeHomeFlowCoordinator()
        
        let workplaceSceneDIContainer = appDIContainer.makeWorkplaceSceneDIContainer()
        let workplaceCoordinator = workplaceSceneDIContainer.makeWorkplaceFlowCoordinator()
        
        let settingSceneDIContainer = appDIContainer.makeSettingSceneDIContainer()
        let settingCoordinator = settingSceneDIContainer.makeSettingFlowCoordinator()
        
        mainCoordinator.coordinators = [
            homeCoordinator, workplaceCoordinator, settingCoordinator
        ]
        return mainCoordinator
    }
}
