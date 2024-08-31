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
    
    // Notice
    
    func makeNoticeUseCase() -> NoticeUseCase {
        return DefaultNoticeUseCase(noticeRepository: makeNoticeRepository())
    }
    
    private func makeNoticeRepository() -> NoticeRepository {
        return DefaultNoticeRepository(network: dependencies.mainNetworking)
    }
    
    // Attedance
    
    func makeAttendanceUseCase() -> AttendanceUseCase {
        return DefaultAttendanceUseCase(repository: makeAttendanceRepository())
    }
    
    private func makeAttendanceRepository() -> AttendanceRepository {
        return DefaultAttendanceRepository(network: AttendanceNetworking())
    }
    
    // Workplace
    
    func makeWorkplaceUseCase() -> WorkplaceUseCase {
        return DefaultWorkplaceUseCase(workplaceRepository: makeWorkplaceRepository())
    }
    
    private func makeWorkplaceRepository() -> WorkplaceRepository {
        return DefaultWorkplaceRepository(network: WorkplaceNetworking(), storage: SQLiteWorkplaceStorage())
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
    
    func makeMainViewController(coordinator: any MainFlowCoordinator) -> MainViewController {
        return MainViewController(
            viewModel: makeMainViewModel(coordinator: coordinator)
        )
    }
    
    func makeMainViewModel(
        coordinator: any MainFlowCoordinator
    ) -> MainViewModel {
        return MainViewModel(
            dependency: (
                coordinator: coordinator,
                attendanceUseCase: makeAttendanceUseCase(),
                workplaceUseCase: makeWorkplaceUseCase(),
                noticeUseCase: makeNoticeUseCase()
            )
        )
    }
    
    func makeWorkplaceListViewController(coordinator: MainFlowCoordinator) -> WorkplacePlaceListViewController {
        return .init(viewModel: makeWorkplaceListViewModel(coordinator: coordinator))
    }
    
    private func makeWorkplaceListViewModel(coordinator: MainFlowCoordinator) -> WorkplaceListViewModel {
        return .init(
            dependencies: (
                coordinator: coordinator,
                workplaceUseCase: makeWorkplaceUseCase()
            )
        )
    }
   
    
    // MARK: - Workplace Finder
    
    func makeWorkplaceFinderViewController(coordinator: any MainFlowCoordinator) -> WorkplaceFinderViewController {
        return WorkplaceFinderViewController(viewModel: makeWorkplaceFinderViewModel(coordinator: coordinator))
    }
    
    private func makeWorkplaceFinderViewModel(coordinator:  any MainFlowCoordinator) -> WorkplaceFinderViewModel {
        return WorkplaceFinderViewModel(
            dependencies: (
                coordinator: coordinator,
                workplaceUseCase: makeWorkplaceUseCase()
            )
        )
    }
    
    // MARK: - Search Workplace
    
    func makeSearchWorkplaceViewController(
        coordinator: any MainFlowCoordinator) -> SearchWorkplaceViewController {
        return SearchWorkplaceViewController(viewModel: makeSearchWorkplaceViewModel(coordinator: coordinator))
    }
    
    private func makeSearchWorkplaceViewModel(
        coordinator: any MainFlowCoordinator) -> SearchWorkplaceViewModel {
        return SearchWorkplaceViewModel(
            dependencies: (
                coordinator: coordinator,
                workplaceUseCase: makeWorkplaceUseCase()
//                validationService: any ValidationService,
//                wireframe: any Wireframe
            )
        )
    }
    
    // MARK: - Add New Workplace
    
    func makeAddNewWorkplaceViewController(
        coordinator: any MainFlowCoordinator) -> AddNewWorkplaceViewController {
            return AddNewWorkplaceViewController(viewModel: makeAddNewWorkplaceViewModel(coordinator: coordinator))
    }
    
    private func makeAddNewWorkplaceViewModel(coordinator: MainFlowCoordinator) -> AddNewWorkplaceViewModel {
        return AddNewWorkplaceViewModel(
            dependencies: (
                coordinator: coordinator,
                workplaceUseCase: makeWorkplaceUseCase(),
                validationService: DefaultValidationService.shared,
                wireframe: DefaultWireframe.shared
            )
        )
    }
    
    // MARK: Workplace Details
    
    func makeWorkplaceDetailsViewController(
        coordinator: any MainFlowCoordinator, workplaceID: Workplace.ID) -> WorkplaceDetailsViewController {
            return WorkplaceDetailsViewController(viewModel: makeWorkplaceDetailsViewModel(coordinator: coordinator, workplaceID: workplaceID))
    }
    
    private func makeWorkplaceDetailsViewModel(coordinator: MainFlowCoordinator, workplaceID: Workplace.ID) -> WorkplaceDetailsViewModel {
        return WorkplaceDetailsViewModel(
            dependencies: (
                coordinator: coordinator,
                workplaceUseCase: makeWorkplaceUseCase(),
                validationService: DefaultValidationService.shared,
                wireframe: DefaultWireframe.shared,
                workplaceID: workplaceID
            )
        )
    }
    
    // MARK: - Member Info
    
    func makeMemberInfoViewController(
        member: Member,
        coordinator: any MainFlowCoordinator
    ) -> MemberInfoViewController {
        return MemberInfoViewController.create(
            viewModel: makeMemberInfoViewModel(
                member: member,
                coordinator: coordinator
            )
        )
    }
    
    private func makeMemberInfoViewModel(
        member: Member,
        coordinator: MainFlowCoordinator
    ) -> MemberInfoViewModel {
        return MemberInfoViewModel(
            dependency: (
                member: member,
                coordinator: coordinator,
                workplaceUseCase: makeWorkplaceUseCase()
            )
        )
    }
    
    // MARK: - Noti List
    
    func makeNotiListViewController(
        workplaceIdentifier: Workplace.ID,
        coordinator: any MainFlowCoordinator
    ) -> NotiListViewController {
        return NotiListViewController(
            viewModel: makeNotiListViewModel(
                workplaceIdentifier: workplaceIdentifier,
                coordinator: coordinator
            )
        )
    }
    
    private func makeNotiListViewModel(
        workplaceIdentifier: Workplace.ID,
        coordinator: MainFlowCoordinator
    ) -> NotiListViewModel {
        return NotiListViewModel(
            dependency: (
                workplaceIdentifier: workplaceIdentifier,
                coordinator: coordinator,
                workplaceUseCase: makeWorkplaceUseCase(),
                noticeUseCase: makeNoticeUseCase()
            )
        )
    }
    
    // MARK: - Notice Detail
    
    func makeNoticeDetailViewController(
        noticeIdentifier: Notice.ID,
        coordinator: any MainFlowCoordinator
    ) -> AnnounceDetailViewController {
        return AnnounceDetailViewController(
            viewModel: makeNoticeDtailViewModel(
                noticeIdentifier: noticeIdentifier,
                coordinator: coordinator,
                noticeUseCase: makeNoticeUseCase()
            )
        )
    }
    
    private func makeNoticeDtailViewModel(
        noticeIdentifier: Notice.ID,
        coordinator: MainFlowCoordinator,
        noticeUseCase: NoticeUseCase
    ) -> AnnounceDetailViewModel {
        return AnnounceDetailViewModel(
            dependencies: (
                noticeIdentifier: noticeIdentifier,
                coordinator: coordinator,
                noticeUseCase: noticeUseCase
            )
        )
    }
}
