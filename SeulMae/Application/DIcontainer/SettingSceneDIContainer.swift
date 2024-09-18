//
//  SettingSceneDIContainer.swift
//  SeulMae
//
//  Created by 조기열 on 9/9/24.
//

import UIKit

final class SettingSceneDIContainer {
    
    struct Dependencies {
        let userNetworking: UserNetworking
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Flow Coordinators
    
    func makeSettingFlowCoordinator(
        // navigationController: UINavigationController
    ) -> SettingFlowCoordinator {
        return DefaultSettingFlowCoordinator(
            // navigationController: navigationController,
            dependencies: self
        )
    }
    
    // MARK: - Private
    
    private func makeUserRepository() -> UserRepository {
        .init(network: dependencies.userNetworking)
    }
    
    private func makeUserUseCase() -> UserUseCase {
        return DefaultUserUseCase(userRepository: makeUserRepository())
    }
       
    private func makeSettingViewModel(
        coordinator: any SettingFlowCoordinator
    ) -> SettingViewModel {
        return .init(
            dependencies: (
                coordinator: coordinator,
                userUseCase: makeUserUseCase()
            )
        )
    }
}

// MARK: - SettingFlowCoordinatorDependencies

extension SettingSceneDIContainer: SettingFlowCoordinatorDependencies {
    
    func makeSettingViewController(
        coordinator: any SettingFlowCoordinator
    ) -> SettingViewController {
        .init(
            viewModel: makeSettingViewModel(coordinator: coordinator)
        )
    }
}
