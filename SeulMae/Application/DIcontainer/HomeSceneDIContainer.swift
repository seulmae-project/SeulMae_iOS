//
//  HomeSceneDIContainer.swift
//  SeulMae
//
//  Created by 조기열 on 9/9/24.
//

import UIKit

final class HomeSceneDIContainer {
    
    struct Dependencies {
        // let mainNetworking: MainNetworking
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Flow Coordinators
    
    func makeHomeFlowCoordinator(
        // navigationController: UINavigationController
    ) -> HomeFlowCoordinator {
        return DefaultHomeFlowCoordinator(
            // navigationController: navigationController,
            dependencies: self
        )
    }
    
    private func makeAttendanceUseCase() -> AttendanceUseCase {
        DefaultAttendanceUseCase(repository: DefaultAttendanceRepository(network: AttendanceNetworking()))
    }
    
    private func makeUserHomeViewModel(
        coordinator: any HomeFlowCoordinator) -> UserHomeViewModel {
        return .init(
            dependencies: (
                coordinator: coordinator,
                attendnaceUseCase: makeAttendanceUseCase()))
    }
}

extension HomeSceneDIContainer: HomeFlowCoordinatorDependencies {
    
    func makeHomeViewController(
        coordinator: any HomeFlowCoordinator
    ) -> UserHomeViewController {
        return .init(viewModel: makeUserHomeViewModel(coordinator: coordinator))
    }
    
    func makeHomeViewController(
        coordinator: any HomeFlowCoordinator
    ) -> ManagerHomeViewController {
        return .init(
            // viewModel: makeManagerHomeViewModel(coordinator: coordinator)
        )
    }
    
    private func makeManagerHomeViewModel(
        coordinator: any HomeFlowCoordinator
    ) {
        
    }
}
