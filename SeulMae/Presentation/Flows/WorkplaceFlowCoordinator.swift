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
    func makeAnnounceDetailsViewController(coordinator: WorkplaceFlowCoordinator, announceId: Announce.ID) -> AnnounceDetailViewController
    
    func makeWorkScheduleListViewController(coordinator: WorkplaceFlowCoordinator) -> WorkScheduleListViewController
    func makeWorkScheduleDetailsViewController(coordinator: WorkplaceFlowCoordinator, workScheduleId: WorkSchedule.ID?) -> WorkScheduleDetailsViewController

    func makeScheduleCreation(coordinator: WorkplaceFlowCoordinator) -> ScheduleCreationViewController


    func makeMemberProfileViewController(coordinator: WorkplaceFlowCoordinator) -> MemberInfoViewController
}

protocol WorkplaceFlowCoordinator: Coordinator {
    func showWorkplace()
    
    func showAnnounceDetails(announceId: Announce.ID)
    func showAnnounceList()
    
    func showWorkScheduleDetails(workScheduleId: WorkSchedule.ID?)
    func showWorkScheduleList()

    func showScheduleCreation()

    func showMemberProfile(memberId: Member.ID)
}

final class DefaultWorkplaceFlowCoordinator: WorkplaceFlowCoordinator {
    
    lazy var nav = UINavigationController()
    var childCoordinators: [any Coordinator] = []
    
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
    
    func start(_ arguments: Any?) {
        showWorkplace()
    }
    
    func goBack() {
        
    }
    
    func showWorkplace() {
        let vc = dependencies.makeWorkplaceViewController(coordinator: self)
        nav.setViewControllers([vc], animated: false)
    }
    
    // MARK: - Announce
    
    func showAnnounceList() {
        let vc = dependencies.makeAnnounceListViewController(coordinator: self)
        nav.pushViewController(vc, animated: true)
    }
    
    func showAnnounceDetails(announceId: Announce.ID) {
        let vc = dependencies.makeAnnounceDetailsViewController(
            coordinator: self,
            announceId: announceId)
        nav.pushViewController(vc, animated: true)
    }
    
    // MARK: - WorkSchedule
    
    func showWorkScheduleDetails(workScheduleId: WorkSchedule.ID?) {
        let vc = dependencies.makeWorkScheduleDetailsViewController(coordinator: self, workScheduleId: workScheduleId)
        nav.pushViewController(vc, animated: true)
    }
    
    func showWorkScheduleList() {
        let vc = dependencies.makeWorkScheduleListViewController(coordinator: self)
        nav.pushViewController(vc, animated: true)
    }

    func showScheduleCreation() {
        let vc = dependencies.makeScheduleCreation(coordinator: self)
        nav.pushViewController(vc, animated: true)
    }

    // MARK: - MemberProfile
    
    func showMemberProfile(memberId: Member.ID) {
        let vc = dependencies.makeMemberProfileViewController(coordinator: self)
        nav.pushViewController(vc, animated: true)
    }
}
