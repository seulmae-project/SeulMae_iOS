//
//  FinderSceneDIContainer.swift
//  SeulMae
//
//  Created by 조기열 on 10/20/24.
//

import UIKit

final class FinderSceneDIContainer {

    struct Dependencies {
        let notificationNetworking: NotificationNetworking
        let workplaceNetworking: WorkplaceNetworking
        let attendanceNetworking: AttendanceNetworking
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Private Methods

    private func makeAttendanceRepository() -> AttendanceRepository {
        return DefaultAttendanceRepository(network: dependencies.attendanceNetworking)
    }

    private func makeAttendanceUseCase() -> AttendanceUseCase {
        return DefaultAttendanceUseCase(repository: makeAttendanceRepository())
    }

    private func makeWorkplaceRepository() -> WorkplaceRepository {
        return DefaultWorkplaceRepository(
            network: dependencies.workplaceNetworking,
            storage: SQLiteWorkplaceStorage()
        )
    }

    private func makeWorkplaceUseCase() -> WorkplaceUseCase {
        return DefaultWorkplaceUseCase(workplaceRepository: makeWorkplaceRepository())
    }

    private func makeNotificationRepository() -> NotificationRepository {
        return DefaultNoticeRepository(network: dependencies.notificationNetworking)
    }

    private func makeNotificationUseCase() -> NotificationUseCase {
        return DefaultNotificationUseCase(noticeRepository: makeNotificationRepository())
    }

    private func makeWorkplaceFinderViewModel(
        coordinator: any FinderFlowCoordinator
    ) -> WorkplaceFinderViewModel {
        return .init(
            dependencies: (
                coordinator: coordinator,
                workplaceUseCase: makeWorkplaceUseCase(),
                notificationUseCase: makeNotificationUseCase()
            )
        )
    }

    private func makeWorkplaceListViewModel(
        coordinator: FinderFlowCoordinator
    ) -> WorkplaceListViewModel {
        return .init(
            dependencies: (
                coordinator: coordinator,
                workplaceUseCase: makeWorkplaceUseCase()
            )
        )
    }

    private func makeSearchWorkplaceViewModel(
        coordinator: any FinderFlowCoordinator
    ) -> PlaceSearchViewModel {
        return PlaceSearchViewModel(
            dependencies: (
                coordinator: coordinator,
                workplaceUseCase: makeWorkplaceUseCase()
                //                validationService: any ValidationService,
                //                wireframe: any Wireframe
            )
        )
    }

    private func makeWorkplaceDetailsViewModel(
        coordinator: FinderFlowCoordinator,
        workplaceId: Workplace.ID
    ) -> WorkplaceDetailsViewModel {
        return .init(
            dependencies: (
                coordinator: coordinator,
                workplaceUseCase: makeWorkplaceUseCase(),
                wireframe: DefaultWireframe.shared,
                workplaceId: workplaceId
            )
        )
    }

    private func makeAddNewWorkplaceViewModel(
        coordinator: FinderFlowCoordinator
    ) -> AddNewWorkplaceViewModel {
        return AddNewWorkplaceViewModel(
            dependencies: (
                coordinator: coordinator,
                workplaceUseCase: makeWorkplaceUseCase(),
                validationService: DefaultValidationService.shared,
                wireframe: DefaultWireframe.shared
            )
        )
    }

    // MARK: - Flow Coordinators

    func makeFinderFlowCoordinator(
        // navigationController: UINavigationController
    ) -> FinderFlowCoordinator {
        return DefaultFinderFlowCoordinator(
            // navigationController: navigationController,
            dependencies: self
        )
    }
}

extension FinderSceneDIContainer: FinderFlowCoordinatorDependencies {

    // MARK: - FinderFlowCoordinatorDependencies

    func makeWorkplaceFinderViewController(
        coordinator: any FinderFlowCoordinator
    ) -> PlaceFinderViewController {
        return .init(
            viewModel: makeWorkplaceFinderViewModel(
                coordinator: coordinator
            ))
    }

    func makeWorkplaceListViewController(
        coordinator: FinderFlowCoordinator
    ) -> WorkplacePlaceListViewController {
        return .init(
            viewModel: makeWorkplaceListViewModel(
                coordinator: coordinator
            ))
    }

    func makeSearchWorkplaceViewController(
        coordinator: any FinderFlowCoordinator
    ) -> SearchWorkplaceViewController {
        return SearchWorkplaceViewController(viewModel: makeSearchWorkplaceViewModel(coordinator: coordinator))
    }

    func makeAddNewWorkplaceViewController(
        coordinator: any FinderFlowCoordinator
    ) -> AddNewWorkplaceViewController {
        return AddNewWorkplaceViewController(
            viewModel: makeAddNewWorkplaceViewModel(
                coordinator: coordinator
            ))
    }

    func makeWorkplaceDetailsViewController(
        coordinator: any FinderFlowCoordinator,
        workplaceID: Workplace.ID
    ) -> WorkplaceDetailsViewController {
        return .init(viewModel: makeWorkplaceDetailsViewModel(
            coordinator: coordinator,
            workplaceId: workplaceID
        ))
    }
}

