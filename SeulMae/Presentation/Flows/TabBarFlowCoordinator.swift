//
//  TabBarFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import UIKit

// MARK: - Dependencies

protocol TabBarFlowCoordinatorDependencies {

}

// MARK: - Coordinator

protocol TabBarFlowCoordinator: Coordinator {
    func showHome(isManager: Bool)
    func showFinder()
    func showReminderList()
}

final class DefaultTabBarFlowCoordinator: TabBarFlowCoordinator {
    
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    private let dependencies: TabBarFlowCoordinatorDependencies
    
    // MARK: - Life Cycle Methods
    
    init(
        navigationController: UINavigationController,
        dependencies: TabBarFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start(_ arguments: Any?) {
        guard let isManager = arguments as? Bool else {
            Swift.fatalError("[Main Flow]: Does not fount arguments")
        }
        
        // showMain(isManager: isManager)
        showFinder()
    }
    
    func showHome(isManager: Bool) {
        childCoordinators.forEach { $0.start(isManager) }
        let viewControllers = childCoordinators
            .filter { !($0 is FinderFlowCoordinator) }
            .map { $0.navigationController }
        let vc = TabBarController(viewContollers: viewControllers, mainCoordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }

    func showFinder() {
        let coordinator = childCoordinators
            .filter { ($0 is FinderFlowCoordinator) }
            .first
        (coordinator as? DefaultFinderFlowCoordinator)?.parentCoordinator = self
        coordinator?.start(navigationController)
    }

    func showReminderList() {
        let coordinator = childCoordinators
            .filter { ($0 is CommonFlowCoordinator) }
            .first
        coordinator?.start(navigationController)
    }
}
