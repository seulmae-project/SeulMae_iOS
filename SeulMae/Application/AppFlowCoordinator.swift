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
        let mainSceneDIContainer = appDIContainer.makeMainSceneDIContainer()
        let mainFlow = mainSceneDIContainer.makeMainFlowCoordinator(navigationController: navigationController)
        let flow = authSceneDIContainer.makeAuthFlowCoordinator(navigationController: navigationController, mainFlowCoordinator: mainFlow)
        flow.start()
    }
}
