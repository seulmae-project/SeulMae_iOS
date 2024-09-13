//
//  HomeFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 9/9/24.
//

import UIKit

protocol HomeFlowCoordinatorDependencies {
   
}

protocol HomeFlowCoordinator: Coordinator {
    func start()
    func goBack()
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
        showHome()
    }
    
    func goBack() {
    
    }
    
    func showHome() {
        
    }
}
