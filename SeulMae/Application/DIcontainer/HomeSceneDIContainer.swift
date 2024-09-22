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
    
    private func makeAttendanceHistoryUseCase() -> AttendanceHistoryUseCase {
        DefaultAttendanceHistoryUseCase(attendanceHistoryRepository: DefaultAttendanceHistoryRepository(network: AttendanceHistoryNetworking()))
    }
    
    private func makeNotiUseCase() -> NoticeUseCase {
        return DefaultNoticeUseCase(noticeRepository: makeNotiRepository())
    }
    
    private func makeNotiRepository() -> NotificationRepository {
        return DefaultNoticeRepository(network: NotificationNetworking())
    }
    
    private func makeUserHomeViewModel(
        coordinator: any HomeFlowCoordinator) -> UserHomeViewModel {
        return .init(
            dependencies: (
                coordinator: coordinator,
                attendanceUseCase: makeAttendanceUseCase(),
                attendanceHistoryUseCase: makeAttendanceHistoryUseCase()
            ))
    }
    
    private func makeManagerHomeViewModel(coordinator: any HomeFlowCoordinator) -> ManagerHomeViewModel {
        return .init(
            dependencies: (
                coordinator: coordinator,
                attendnaceUseCase: makeAttendanceUseCase()))
    }
    
    private func makeNotiListViewModel(
        coordinator: any HomeFlowCoordinator) -> NotiListViewModel {
            .init(
                dependency: (
                    coordinator: coordinator,
                    noticeUseCase: makeNotiUseCase()))
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
            viewModel: makeManagerHomeViewModel(coordinator: coordinator)
        )
    }
    
    func makeNotiListViewController(
        coordinator: HomeFlowCoordinator) -> NotiListViewController {
            return .init(viewModel: makeNotiListViewModel(coordinator: coordinator))
        }
}
