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
        var authCoordinator = makeAuthCoordinator()
        let mainCoordinator = makeMainCoordinator()
        authCoordinator.childCoordinators.append(mainCoordinator)
        authCoordinator.start(nil)
    }

    func makeAuthCoordinator() -> AuthFlowCoordinator {
        let authSceneDIContainer = appDIContainer.makeAuthSceneDIContainer()
        var authCoordinator = authSceneDIContainer.makeAuthFlowCoordinator(
            navigationController: navigationController)
        return authCoordinator
    }

    func makeMainCoordinator() -> TabBarFlowCoordinator {
        let mainSceneDIContainer = appDIContainer.makeTabBarSceneDIContainer()
        var mainCoordinator = mainSceneDIContainer.makeMainFlowCoordinator(navigationController: navigationController)
        
        let homeSceneDIContainer = appDIContainer.makeHomeSceneDIContainer()
        let homeCoordinator = homeSceneDIContainer.makeHomeFlowCoordinator()
        
        let workplaceSceneDIContainer = appDIContainer.makeWorkplaceSceneDIContainer()
        let workplaceCoordinator = workplaceSceneDIContainer.makeWorkplaceFlowCoordinator()
        
        let settingSceneDIContainer = appDIContainer.makeSettingSceneDIContainer()
        let settingCoordinator = settingSceneDIContainer.makeSettingFlowCoordinator()

        let finderSceneDIContainer = appDIContainer.makeFinderSceneDIContainer()
        let finderCoordinator = finderSceneDIContainer.makeFinderFlowCoordinator()

        let commonSceneDIContainer = appDIContainer.makeCommonSceneDIContainer()
        let commonCoordinator = commonSceneDIContainer.makeCommonFlowCoordinator()

        mainCoordinator.childCoordinators = [
            finderCoordinator, homeCoordinator, workplaceCoordinator, settingCoordinator, commonCoordinator
        ]
        return mainCoordinator
    }
}
