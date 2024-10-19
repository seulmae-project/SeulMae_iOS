//
//  HomeSceneDIContainer.swift
//  SeulMae
//
//  Created by 조기열 on 9/9/24.
//

import UIKit

final class HomeSceneDIContainer {
    
    struct Dependencies {
        let attendanceNetworking: AttendanceNetworking
        let workplaceNetworking: WorkplaceNetworking
        let notificationNetworking: NotificationNetworking
        let attendanceHistoryNetworking: AttendanceHistoryNetworking
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
    
    // MARK: - Private Methods

    private func makeAttendanceRepository() -> AttendanceRepository {
        return DefaultAttendanceRepository(network: dependencies.attendanceNetworking)
    }

    private func makeAttendanceUseCase() -> AttendanceUseCase {
        DefaultAttendanceUseCase(repository: self.makeAttendanceRepository())
    }

    private func makeAttendanceHistoryRepository() -> AttendanceHistoryRepository {
        return DefaultAttendanceHistoryRepository(network: dependencies.attendanceHistoryNetworking)
    }

    private func makeAttendanceHistoryUseCase() -> AttendanceHistoryUseCase {
        return DefaultAttendanceHistoryUseCase(attendanceHistoryRepository: self.makeAttendanceHistoryRepository())
    }

    private func makeWorkplaceRepository() -> WorkplaceRepository {
        return DefaultWorkplaceRepository(
            network: dependencies.workplaceNetworking,
            storage: SQLiteWorkplaceStorage()
        )
    }

    private func makeWorkplaceUseCase() -> WorkplaceUseCase {
        return DefaultWorkplaceUseCase(workplaceRepository: self.makeWorkplaceRepository())
    }

    private func makeNotificationRepository() -> NotificationRepository {
        return DefaultNoticeRepository(network: dependencies.notificationNetworking)
    }

    private func makeNotificationUseCase() -> NoticeUseCase {
        return DefaultNoticeUseCase(noticeRepository: self.makeNotificationRepository())
    }

    private func makeUserHomeViewModel(
        coordinator: any HomeFlowCoordinator) -> UserHomeViewModel {
            return .init(
                dependencies: (
                    coordinator: coordinator,
                    workplaceUseCase: self.makeWorkplaceUseCase(),
                    attendanceUseCase: self.makeAttendanceUseCase(),
                    attendanceHistoryUseCase: self.makeAttendanceHistoryUseCase()
                ))
        }

    private func makeManagerHomeViewModel(coordinator: any HomeFlowCoordinator) -> ManagerHomeViewModel {
        return .init(
            dependencies: (
                coordinator: coordinator,
                attendnaceUseCase: self.makeAttendanceUseCase()
            ))
    }

    private func makeNotificationListViewModel(
        coordinator: HomeFlowCoordinator) -> NotiListViewModel {
            return .init(
                dependency: (
                    coordinator: coordinator,
                    noticeUseCase: makeNotificationUseCase()
                ))
    }

    private func makeScheduleReminderViewModel(
        coordinator: any HomeFlowCoordinator) -> ScheduleReminderViewModel {
            return .init(
                dependencies: (
                    coordinator: coordinator,
                    workplaceUseCase: makeWorkplaceUseCase()
                ))
        }
    
    private func makeWorkTimeRecordingViewModel(
        coordinator: any HomeFlowCoordinator) -> WorkTimeRecordingViewModel {
            return .init(
                dependencies: (
                    coordinator: coordinator,
                    workplaceUseCase: makeWorkplaceUseCase(),
                    atendanceHistoryUseCase: makeAttendanceHistoryUseCase(),
                    workTimeCalculator: AttendanceService()
                )
            )
        }
}

extension HomeSceneDIContainer: HomeFlowCoordinatorDependencies {
    
    // MARK: - HomeFlowCoordinatorDependencies
    
    func makeMemberHomeViewController(
        coordinator: any HomeFlowCoordinator) -> UserHomeViewController {
            return .init(viewModel: makeUserHomeViewModel(coordinator: coordinator))
        }
    
    func makeManagerHomeViewController(
        coordinator: any HomeFlowCoordinator) -> ManagerHomeViewController {
            return .init(
                viewModel: makeManagerHomeViewModel(coordinator: coordinator)
            )
    }
    
    func makeNotiListViewController(
        coordinator: any HomeFlowCoordinator) -> NotiListViewController {
            return .init(
            viewModel: makeNotificationListViewModel(coordinator: coordinator)
        )
    }

    func makeScheduleReminderViewController(
        coordinator: any HomeFlowCoordinator) -> ScheduleReminderViewController {
            return ScheduleReminderViewController(
                viewModel: makeScheduleReminderViewModel(coordinator: coordinator)
            )
        }
    
    func makeWorkTimeRecordingViewController(
        coordinator: any HomeFlowCoordinator) -> WorkTimeRecordingViewController {
            return WorkTimeRecordingViewController(
                viewModel: makeWorkTimeRecordingViewModel(coordinator: coordinator)
            )
        }
    
    func makeWorkLogSummaryViewController(
        coordinator: any HomeFlowCoordinator) -> WorkLogViewController {
            return .init(
                coordinator: coordinator,
                workplaceUseCase: makeWorkplaceUseCase(),
                attendanceUseCase: makeAttendanceUseCase())
    }
}
