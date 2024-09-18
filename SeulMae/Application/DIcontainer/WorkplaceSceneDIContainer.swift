//
//  WorkplaceSceneDIContainer.swift
//  SeulMae
//
//  Created by 조기열 on 9/9/24.
//

import UIKit

final class WorkplaceSceneDIContainer {
    
    struct Dependencies {
        let workScheduleNetworking: WorkScheduleNetworking
        let mainNetworking: AnnounceNetworking
        let memberNetworking: UserNetworking
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Flow Coordinators
    
    func makeWorkplaceFlowCoordinator(
        // navigationController: UINavigationController
    ) -> WorkplaceFlowCoordinator {
        return DefaultWorkplaceFlowCoordinator(
            // navigationController: navigationController,
            dependencies: self
        )
    }
    
    // MARK: - Private
    
    private func makeMemberRepository() -> MemberRepository {
        DefaultMemberRepository(network: dependencies.memberNetworking)
    }
    
    private func makeAnnounceRepository() -> AnnounceRepository {
        DefaultAnnounceRepository(network: dependencies.mainNetworking)
    }
    
    private func makeWorkScheduleRepository() -> WorkScheduleRepository {
        return DefaultWorkScheduleRepository(network: dependencies.workScheduleNetworking)
    }
        
    private func makeMemberUseCase() -> MemberUseCase {
        return DefaultMemberUseCase()
    }
    
    private func makeAnnounceUseCase() -> AnnounceUseCase {
        return DefaultAnnounceUseCase(announceRepository: makeAnnounceRepository())
    }
   
    private func makeWorkScheduleUseCase() -> WorkScheduleUseCase {
        return DefaultWorkScheduleUseCase(workScheduleRepository: makeWorkScheduleRepository())
    }
    
    private func makeWorkplaceUseCase() -> WorkplaceUseCase {
        return DefaultWorkplaceUseCase(workplaceRepository: DefaultWorkplaceRepository(
            network: WorkplaceNetworking(),
            storage: SQLiteWorkplaceStorage()))
    }
    
    private func makeWorkplaceViewModel(coordinator: any WorkplaceFlowCoordinator) -> WorkplaceViewModel {
        return .init(
            dependencies: (
                coordinator: coordinator,
                workplaceUseCase: makeWorkplaceUseCase(),
                memberUseCase: makeMemberUseCase(),
                announceUseCase: makeAnnounceUseCase(),
                workScheduleUseCase: makeWorkScheduleUseCase()
            )
        )
    }
    
    private func makeAnnounceListViewModel(
        coordinator: any WorkplaceFlowCoordinator
    ) -> AnnounceListViewModel {
        return .init(
            coordinator: coordinator,
            announceUseCase: makeAnnounceUseCase()
        )
    }
    
    private func makeAnnounceDetailViewModel(
        coordinator: any WorkplaceFlowCoordinator,
        announceId: Announce.ID
    ) -> AnnounceDetailViewModel {
        return .init(
            dependencies: (
                coordinator: coordinator,
                announceUseCase: makeAnnounceUseCase(),
                wireframe: DefaultWireframe(),
                announceId: announceId
            )
        )
    }
    
    private func makeWorkScheduleDetailsViewModel(
        coordinator: any WorkplaceFlowCoordinator,
        workScheduleId: WorkSchedule.ID) -> WorkScheduleDetailsViewModel {
            return .init(
                dependencies: (
                    coordinator: coordinator,
                    workScheduleUseCase: makeWorkScheduleUseCase(),
                    workScheduleId: workScheduleId))
    }
    
    private func makeWorkScheduleListViewModel(
        coordinator: any WorkplaceFlowCoordinator) -> WorkScheduleListViewModel {
        return .init(
            dependencies: (
                coordinator: coordinator,
                workScheduleUseCase: makeWorkScheduleUseCase()))
    }
}

extension WorkplaceSceneDIContainer: WorkplaceFlowCoordinatorDependencies {
    
    // MARK: - WorkplaceFlowCoordinatorDependencies
    
    func makeWorkplaceViewController(coordinator: any WorkplaceFlowCoordinator) -> WorkplaceViewController {
        return .init(
            viewModel: makeWorkplaceViewModel(coordinator: coordinator))
    }
    
    func makeAnnounceListViewController(
        coordinator: any WorkplaceFlowCoordinator
    ) -> AnnounceListViewController {
        return .init(
            viewModel: makeAnnounceListViewModel(coordinator: coordinator)
        )
    }
    
    func makeAnnounceDetailsViewController(
        coordinator: any WorkplaceFlowCoordinator,
        announceId: Announce.ID
    ) -> AnnounceDetailViewController {
        return .init(
            viewModel: makeAnnounceDetailViewModel(
                coordinator: coordinator,
                announceId: announceId
            )
        )
    }
    
    func makeWorkScheduleDetailsViewController(
        coordinator: any WorkplaceFlowCoordinator,
        workScheduleId: WorkSchedule.ID) -> WorkScheduleDetailsViewController {
            return .init(viewModel: makeWorkScheduleDetailsViewModel(coordinator: coordinator, workScheduleId: workScheduleId))
    }
    
    func makeWorkScheduleListViewController(
        coordinator: any WorkplaceFlowCoordinator
    ) -> WorkScheduleListViewController {
        return .init(viewModel: makeWorkScheduleListViewModel(coordinator: coordinator))
    }
    
    func makeMemberProfileViewController(
        coordinator: any WorkplaceFlowCoordinator
    ) -> MemberInfoViewController {
        return .init()
    }
}
