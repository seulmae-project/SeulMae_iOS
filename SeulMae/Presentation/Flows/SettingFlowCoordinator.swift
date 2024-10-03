//
//  SettingFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 9/9/24.
//

import UIKit

protocol SettingFlowCoordinatorDependencies {
    func makeSettingViewController(coordinator: SettingFlowCoordinator) -> SettingViewController
   
}

protocol SettingFlowCoordinator: Coordinator {
    func showSetting()
}

final class DefaultSettingFlowCoordinator: SettingFlowCoordinator {
    
    lazy var navigationController = UINavigationController()
    var coordinators: [any Coordinator] = []
    
    // MARK: - Dependencies
    
    private let dependencies: SettingFlowCoordinatorDependencies
    
    // MARK: - Life Cycle Methods
    
    init(
        // navigationController: UINavigationController,
        dependencies: SettingFlowCoordinatorDependencies
    ) {
        // self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start(_ arguments: Any?) {
        showSetting()
    }
    
    func goBack() {
        
    }
    
    func showSetting() {
        let vc = dependencies.makeSettingViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }
}
