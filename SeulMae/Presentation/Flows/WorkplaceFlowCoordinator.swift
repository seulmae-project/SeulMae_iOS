//
//  WorkplaceFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 9/9/24.
//

import UIKit

protocol WorkplaceFlowCoordinatorDependencies {
    func makeWorkplaceViewController(coordinator: WorkplaceFlowCoordinator) -> WorkplaceViewController
    
    func makeAnnounceListViewController(coordinator: WorkplaceFlowCoordinator) -> AnnounceListViewController
    func makeAnnounceDetailViewController(coordinator: WorkplaceFlowCoordinator, announceId: Announce.ID) -> AnnounceDetailViewController
    
    func makeWorkScheduleDetailsViewController(coordinator: WorkplaceFlowCoordinator) -> WorkScheduleDetailsViewController
    func makeWorkScheduleListViewController(coordinator: WorkplaceFlowCoordinator) -> WorkScheduleListViewController
    
    func makeMemberProfileViewController(coordinator: WorkplaceFlowCoordinator) -> MemberInfoViewController
}

protocol WorkplaceFlowCoordinator: Coordinator {
    func showWorkplace()
    
    func showAnnounceDetails(announceId: Announce.ID)
    func showAnnounceList()
    
    func showWorkScheduleDetails(workScheduleId: WorkSchedule.ID)
    func showWorkScheduleList()
    
    func showMemberProfile(memberId: Member.ID)
}

final class DefaultWorkplaceFlowCoordinator: WorkplaceFlowCoordinator {
    
    lazy var navigationController = UINavigationController()
    var coordinators: [any Coordinator] = []
    
    // MARK: - Dependencies
    
    private let dependencies: WorkplaceFlowCoordinatorDependencies
    
    // MARK: - Life Cycle Methods
    
    init(
        // navigationController: UINavigationController,
        dependencies: WorkplaceFlowCoordinatorDependencies
    ) {
        // self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        showWorkplace()
    }
    
    func goBack() {
        
    }
    
    func showWorkplace() {
        let vc = dependencies.makeWorkplaceViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    // MARK: - Announce
    
    func showAnnounceList() {
        let vc = dependencies.makeAnnounceListViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showAnnounceDetails(announceId: Announce.ID) {
        let vc = dependencies.makeAnnounceDetailViewController(
            coordinator: self,
            announceId: announceId)
        navigationController.pushViewController(vc, animated: true)
    }
    
    // MARK: - WorkSchedule
    
    func showWorkScheduleDetails(workScheduleId: WorkSchedule.ID) {
        let vc = dependencies.makeWorkScheduleDetailsViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showWorkScheduleList() {
        let vc = dependencies.makeWorkScheduleListViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    // MARK: - MemberProfile
    
    func showMemberProfile(memberId: Member.ID) {
        let vc = dependencies.makeMemberProfileViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
}