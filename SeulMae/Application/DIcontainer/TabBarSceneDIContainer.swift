//
//  TabBarSceneDIContainer.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import UIKit

final class TabBarSceneDIContainer {

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

    private func makeMainViewModel(
        coordinator: any TabBarFlowCoordinator
    ) -> MainViewModel {
        return MainViewModel(
            dependency: (
                coordinator: coordinator,
                attendanceUseCase: makeAttendanceUseCase(),
                workplaceUseCase: makeWorkplaceUseCase(),
                noticeUseCase: makeNotificationUseCase()
            )
        )
    }

    private func makeWorkplaceFinderViewModel(
        coordinator:  any TabBarFlowCoordinator
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
        coordinator: TabBarFlowCoordinator
    ) -> WorkplaceListViewModel {
        return .init(
            dependencies: (
                coordinator: coordinator,
                workplaceUseCase: makeWorkplaceUseCase()
            )
        )
    }

    private func makeSearchWorkplaceViewModel(
        coordinator: any TabBarFlowCoordinator
    ) -> SearchWorkplaceViewModel {
        return SearchWorkplaceViewModel(
            dependencies: (
                coordinator: coordinator,
                workplaceUseCase: makeWorkplaceUseCase()
                //                validationService: any ValidationService,
                //                wireframe: any Wireframe
            )
        )
    }

    private func makeWorkplaceDetailsViewModel(
        coordinator: TabBarFlowCoordinator,
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
        coordinator: TabBarFlowCoordinator
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

    func makeMainFlowCoordinator(
        navigationController: UINavigationController
    ) -> TabBarFlowCoordinator {
        return DefaultTabBarFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}

extension TabBarSceneDIContainer: TabBarFlowCoordinatorDependencies {

    // MARK: - TabBarFlowCoordinatorDependencies

    func makeTabBarViewController(
        coordinator: any TabBarFlowCoordinator
    ) -> MainViewController {
        return .init(
            viewModel: makeMainViewModel(
                coordinator: coordinator
            ))
    }

    func makeWorkplaceListViewController(
        coordinator: TabBarFlowCoordinator
    ) -> WorkplacePlaceListViewController {
        return .init(
            viewModel: makeWorkplaceListViewModel(
                coordinator: coordinator
            ))
    }

    func makeWorkplaceFinderViewController(
        coordinator: any TabBarFlowCoordinator
    ) -> WorkplaceFinderViewController {
        return .init(
            viewModel: makeWorkplaceFinderViewModel(
                coordinator: coordinator
            ))
    }

    func makeSearchWorkplaceViewController(
        coordinator: any TabBarFlowCoordinator
    ) -> SearchWorkplaceViewController {
        return SearchWorkplaceViewController(viewModel: makeSearchWorkplaceViewModel(coordinator: coordinator))
    }

    func makeAddNewWorkplaceViewController(
        coordinator: any TabBarFlowCoordinator
    ) -> AddNewWorkplaceViewController {
        return AddNewWorkplaceViewController(
            viewModel: makeAddNewWorkplaceViewModel(
                coordinator: coordinator
            ))
    }

    func makeWorkplaceDetailsViewController(
        coordinator: any TabBarFlowCoordinator,
        workplaceID: Workplace.ID
    ) -> WorkplaceDetailsViewController {
        return .init(viewModel: makeWorkplaceDetailsViewModel(
            coordinator: coordinator,
            workplaceId: workplaceID
        ))
    }

    // MARK: - Member Info

    func makeMemberInfoViewController(
        member: Member,
        coordinator: any TabBarFlowCoordinator
    ) -> MemberInfoViewController {
        return MemberInfoViewController.create(
            viewModel: makeMemberInfoViewModel(
                member: member,
                coordinator: coordinator
            ))
    }

    private func makeMemberInfoViewModel(
        member: Member,
        coordinator: TabBarFlowCoordinator
    ) -> MemberInfoViewModel {
        return MemberInfoViewModel(
            dependency: (
                member: member,
                coordinator: coordinator,
                workplaceUseCase: makeWorkplaceUseCase()
            )
        )
    }
}
