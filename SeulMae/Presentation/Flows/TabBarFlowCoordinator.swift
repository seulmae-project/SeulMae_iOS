//
//  TabBarFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import UIKit

// MARK: - Dependencies

protocol TabBarFlowCoordinatorDependencies {
    func makeWorkplaceFinderViewController(coordinator: TabBarFlowCoordinator) -> WorkplaceFinderViewController
    func makeSearchWorkplaceViewController(coordinator: TabBarFlowCoordinator) -> SearchWorkplaceViewController
    func makeWorkplaceDetailsViewController(coordinator: TabBarFlowCoordinator, workplaceID: Workplace.ID) -> WorkplaceDetailsViewController
    func makeAddNewWorkplaceViewController(coordinator: TabBarFlowCoordinator) -> AddNewWorkplaceViewController
}

// MARK: - Coordinator

protocol TabBarFlowCoordinator: Coordinator {
    func showWorkplaceFinder()
    func showSearchWorkPlace()
    func showWorkplaceDetails(workplaceID: Workplace.ID)
    func showAddNewWorkplace()
}

final class DefaultTabBarFlowCoordinator: TabBarFlowCoordinator {
    
    var coordinators: [any Coordinator] = []
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
            // return
        }
        
        // showMain(isManager: isManager)
        showWorkplaceFinder()
    }
    
    func showMain(isManager: Bool) {
        coordinators.forEach { $0.start(isManager) }
        let viewControllers = coordinators.map { $0.navigationController }
        let vc = MainTabBarController(viewContollers: viewControllers, mainCoordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }

    func showWorkplaceFinder() {
        let vc = dependencies.makeWorkplaceFinderViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func showSearchWorkPlace() {
        let vc = dependencies.makeSearchWorkplaceViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    //    func showWorkplaceList() {
    //        let contentViewController = dependencies.makeWorkplaceListViewController(coordinator: self)
    //        let bottomSheetController = BottomSheetController(contentViewController: contentViewController)
    //        navigationController.present(bottomSheetController, animated: true)
    //    }
    
    func showWorkplaceDetails(workplaceID: Workplace.ID) {
        let vc = dependencies.makeWorkplaceDetailsViewController(coordinator: self, workplaceID: workplaceID)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showAddNewWorkplace() {
        let vc = dependencies.makeAddNewWorkplaceViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
}
