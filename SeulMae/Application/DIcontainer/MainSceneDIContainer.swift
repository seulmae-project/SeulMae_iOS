//
//  MainSceneDIContainer.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import UIKit

final class MainSceneDIContainer {
    
    struct Dependencies {
        let mainNetworking: MainNetworking
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeMainUseCase() -> MainUseCase {
        return DefaultMainUseCase(mainRepository: makeMainRepository())
    }
    
    private func makeMainRepository() -> MainRepository {
        return DefaultMainRepository(network: dependencies.mainNetworking)
    }
    
    // MARK: - Flow Coordinators
    
    func makeMainFlowCoordinator(
        navigationController: UINavigationController
    ) -> MainFlowCoordinator {
        return DefaultMainFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}

extension MainSceneDIContainer: MainFlowCoordinatorDependencies {
   
    // MARK: - Main
    
    func makeMainViewController(coordinator: any MainFlowCoordinator) -> ViewController {
        return ViewController()
    }

    
//    func makeAccountSetupViewController(coordinator: any AuthFlowCoordinator
//    ) -> AccountSetupViewController {
//        return .create(viewModel: makeAccountSetupViewModel(coordinator: coordinator))
//    }
//    
//    private func makeAccountSetupViewModel(coordinator: AuthFlowCoordinator
//    ) -> AccountSetupViewModel {
//        return AccountSetupViewModel(
//            dependency: (
//                authUseCase: makeMapUseCase(),
//                coordinator: coordinator
//            )
//        )
//    }
}
