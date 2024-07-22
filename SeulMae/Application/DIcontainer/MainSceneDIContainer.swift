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
    
    func makeNoticeUseCase() -> NoticeUseCase {
        return DefaultNoticeUseCase(noticeRepository: makeNoticeRepository())
    }
    
    private func makeNoticeRepository() -> NoticeRepository {
        return DefaultNoticeRepository(network: dependencies.mainNetworking)
    }
    
    func makeWorkplaceUseCase() -> WorkplaceUseCase {
        return DefaultWorkplaceUseCase(workplaceRepository: makeWorkplaceRepository())
    }
    
    private func makeWorkplaceRepository() -> WorkplaceRepository {
        return DefaultWorkplaceRepository()
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
        return MainViewController.create(
            viewModel: makeMainViewModel(coordinator: coordinator)
        )
    }
    
    func makeMainViewModel(
        coordinator: any MainFlowCoordinator
    ) -> MainViewModel {
        return MainViewModel(
            dependency: (
                coordinator: coordinator,
                workplaceUseCase: makeWorkplaceUseCase(),
                noticeUseCase: makeNoticeUseCase()
            )
        )
    }
    
    // MARK: - Search Place
    
    func makeSearchPlaceViewController(coordinator: any MainFlowCoordinator) -> SearchPlaceViewController {
        return SearchPlaceViewController()
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
        coordinator: any MainFlowCoordinator
    ) -> NotiListViewController {
        return NotiListViewController.create(
            viewModel: makeNotiListViewModel(
                coordinator: coordinator
            )
        )
    }
    
    private func makeNotiListViewModel(
        coordinator: MainFlowCoordinator
    ) -> NotiListViewModel {
        return NotiListViewModel(
            dependency: (
                coordinator: coordinator,
                workplaceUseCase: makeWorkplaceUseCase(),
                noticeUseCase: makeNoticeUseCase()
            )
        )
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
