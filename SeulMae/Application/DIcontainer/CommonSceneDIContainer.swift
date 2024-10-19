//
//  CommonSceneDIContainer.swift
//  SeulMae
//
//  Created by 조기열 on 10/20/24.
//

import UIKit

final class CommonSceneDIContainer {

    struct Dependencies {
        let notificationNetworking: NotificationNetworking
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Flow Coordinators

    func makeCommonFlowCoordinator(
        // navigationController: UINavigationController
    ) -> CommonFlowCoordinator {
        return DefaultCommonFlowCoordinator(
            // navigationController: navigationController,
            dependencies: self
        )
    }

    // MARK: - Private Methods

    private func makeNotificationRepository() -> NotificationRepository {
        return DefaultNoticeRepository(network: dependencies.notificationNetworking)
    }

    private func makeNotificationUseCase() -> NotificationUseCase {
        return DefaultNotificationUseCase(noticeRepository: self.makeNotificationRepository())
    }

    private func makeReminderListViewModel(
        coordinator: CommonFlowCoordinator) -> ReminderListViewModel {
            return .init(
                dependency: (
                    coordinator: coordinator,
                    noticeUseCase: makeNotificationUseCase()
                ))
    }
}

extension CommonSceneDIContainer: CommonFlowCoordinatorDependencies {

    // MARK: - CommonFlowCoordinatorDependencies

    func makeReminderListViewController(
        coordinator: any CommonFlowCoordinator) -> ReminderListViewController {
            return .init(
            viewModel: makeReminderListViewModel(coordinator: coordinator)
        )
    }
}
