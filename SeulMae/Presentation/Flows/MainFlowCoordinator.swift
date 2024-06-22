//
//  MainFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import UIKit

protocol MainFlowCoordinatorDependencies {
    func makeMainViewController(coordinator: MainFlowCoordinator) -> ViewController
}

protocol MainFlowCoordinator {
    
    func start()
    
    /// - Tag: Main
    func showMain()
}

final class DefaultMainFlowCoordinator: MainFlowCoordinator {
    
    // MARK: - Dependency
    
    private let navigationController: UINavigationController
    private let dependencies: MainFlowCoordinatorDependencies
    
    // MARK: - Life Cycle Methods
    
    init(
        navigationController: UINavigationController,
        dependencies: MainFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        showMain()
    }
    
    // MARK: - Signin
    
    func showMain() {
        let vc = dependencies.makeMainViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }
}
