//
//  MainFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import UIKit

protocol MainFlowCoordinatorDependencies {
    func makeMainViewController(coordinator: MainFlowCoordinator) -> MainViewController
    func makeMemberInfoViewController(member: Member, coordinator: MainFlowCoordinator) -> MemberInfoViewController
    func makeWorkplaceListViewController(coordinator: MainFlowCoordinator) -> WorkplacePlaceListViewController
    
    
    // MARK: - Notice Flow Dependencies
    func makeNotiListViewController(workplaceIdentifier: Workplace.ID, coordinator: MainFlowCoordinator) -> NotiListViewController
   
    
    // MARK: Workplace Flow Dependencies
    func makeWorkplaceFinderViewController(coordinator: MainFlowCoordinator) -> WorkplaceFinderViewController
    func makeSearchWorkplaceViewController(coordinator: MainFlowCoordinator) -> SearchWorkplaceViewController
    func makeWorkplaceDetailsViewController(coordinator: MainFlowCoordinator, workplaceID: Workplace.ID) -> WorkplaceDetailsViewController
    func makeAddNewWorkplaceViewController(coordinator: MainFlowCoordinator) -> AddNewWorkplaceViewController
    
    // MARK: - Announce Flow Dependencies
    func makeAnnounceViewController(coordinator: MainFlowCoordinator) -> AnnounceViewController
    func makeAnnounceDetailViewController(coordinator: MainFlowCoordinator, announceId: Announce.ID?) -> AnnounceDetailViewController
    
    // MARK: - Setting
    func makeWorkplaceViewController(coordinator: MainFlowCoordinator) -> WorkplaceViewController
    func makeSettingViewController(coordinator: MainFlowCoordinator) -> SettingViewController
}

protocol MainFlowCoordinator {
    
    func start()
    func goBack()
    func showMain()
    func showMemberInfo(member: Member)
    func showNotiList(workplaceIdentifier: Workplace.ID)
    
    //
    
    
    func showAnnounceList()
    func showAnnounceDetails(announceId: Announce.ID?)
    
    // Workplace Flow
    // func showTutorial()
    func showWorkplaceFinder()
    func showSearchWorkPlace()
    func showWorkplaceDetails(workplaceID: Workplace.ID)
    func showAddNewWorkplace()
    
    // modal
    func showWorkplaceList()
    
    // Workplace Tab
    
    func showWorkScheduleDetails(workScheduleId: WorkSchedule.ID)
    func showWorkScheduleList()
    // setting
    
}

final class DefaultMainFlowCoordinator: MainFlowCoordinator {
    
    // MARK: - Dependency
    
    private let navigationController: UINavigationController
    private let dependencies: MainFlowCoordinatorDependencies
    
    // MARK: - Life Cycle Methods
    
    init(
        navigationController: UINavigationController,
        dependencies: MainFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        showMain()
    }
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
    
    func showWorkplaceList() {
        let contentViewController = dependencies.makeWorkplaceListViewController(coordinator: self)
        let bottomSheetController = BottomSheetController(contentViewController: contentViewController)
        navigationController.present(bottomSheetController, animated: true)
    }
    
    // MARK: - Main
    
    func showMain() {
        let viewControllers = [
            UserHomeViewController(),
            dependencies.makeWorkplaceViewController(coordinator: self),
            dependencies.makeSettingViewController(coordinator: self)
        ]
        
        let vc = MainTabBarController(viewContollers: viewControllers)
//        let vc = dependencies.makeMainViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }

    func showMemberInfo(member: Member) {
        let vc = dependencies.makeMemberInfoViewController(
            member: member,
            coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showNotiList(workplaceIdentifier: Workplace.ID) {
        let vc = dependencies.makeNotiListViewController(
            workplaceIdentifier: workplaceIdentifier,
            coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    
    // MARK: - Workplace Flow
    
    func showWorkplaceFinder() {
        let vc = dependencies.makeWorkplaceFinderViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: true)
    }
    
    func showSearchWorkPlace() {
        let vc = dependencies.makeSearchWorkplaceViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showWorkplaceDetails(workplaceID: Workplace.ID) {
        let vc = dependencies.makeWorkplaceDetailsViewController(coordinator: self, workplaceID: workplaceID)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showAddNewWorkplace() {
        let vc = dependencies.makeAddNewWorkplaceViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    
    // MARK: - Announce
    
    func showAnnounceList() {
        let vc = dependencies.makeAnnounceViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showAnnounceDetails(announceId: Announce.ID?) {
        let vc = dependencies.makeAnnounceDetailViewController(
            coordinator: self,
            announceId: announceId)
        navigationController.pushViewController(vc, animated: true)
    }
    
    // MARK: - WorkSchedule
    
    func showWorkScheduleDetails(workScheduleId: WorkSchedule.ID) {
        let vc = WorkScheduleDetailsViewController()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showWorkScheduleList() {
        let vc = WorkScheduleListViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
