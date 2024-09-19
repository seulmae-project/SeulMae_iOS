//
//  HomeFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 9/9/24.
//

import UIKit

protocol HomeFlowCoordinatorDependencies {
    func makeNotiListViewController(coordinator: HomeFlowCoordinator) -> NotiListViewController
}

protocol HomeFlowCoordinator: Coordinator {
    func start()
    func goBack()
    
    func showUserHome()
    func showManagerHome()
    func showNotiList()
}

final class DefaultHomeFlowCoordinator: HomeFlowCoordinator {
    
    var coordinators = [any Coordinator]()
    lazy var navigationController = UINavigationController()
    
    // MARK: - Dependency
    
    private let dependencies: HomeFlowCoordinatorDependencies
    
    // MARK: - Life Cycle Methods
    
    init(
        // navigationController: UINavigationController,
        dependencies: HomeFlowCoordinatorDependencies
    ) {
        // self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        showUserHome()
    }
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
    
    func showUserHome() {
        
    }
    
    func showManagerHome() {
        
    }
    
    func showNotiList() {
        let vc = dependencies.makeNotiListViewController(
            coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
}
