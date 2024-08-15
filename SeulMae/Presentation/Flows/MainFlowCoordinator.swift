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
    
    
    // MARK: - Notice Flow Dependencies
    func makeNotiListViewController(workplaceIdentifier: Workplace.ID, coordinator: MainFlowCoordinator) -> NotiListViewController
    func makeNoticeDetailViewController(noticeIdentifier: Notice.ID, coordinator: MainFlowCoordinator) -> NoticeDetailViewController
    
    // MARK: Workplace Flow Dependencies
    func makeWorkplaceFinderViewController(coordinator: MainFlowCoordinator) -> WorkplaceFinderViewController
    func makeSearchWorkplaceViewController(coordinator: MainFlowCoordinator) -> SearchWorkplaceViewController
    func makeWorkplaceDetailsViewController(coordinator: MainFlowCoordinator, workplaceID: Workplace.ID) -> WorkplaceDetailsViewController
    func makeAddNewWorkplaceViewController(coordinator: MainFlowCoordinator) -> AddNewWorkplaceViewController
}

protocol MainFlowCoordinator {
    
    func start()
    func goBack()
    func showMain()
    func showMemberInfo(member: Member)
    func showNotiList(workplaceIdentifier: Workplace.ID)
    func showNotiDetail(noticeIdentifier: Notice.ID)
    
    // Workplace Flow
    // func showTutorial()
    func showWorkplaceFinder()
    func showSearchWorkPlace()
    func showWorkplaceDetails(workplaceID: Workplace.ID)
    func showAddNewWorkplace()
    
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
    
    // MARK: - Main
    
    func showMain() {
        let vc = dependencies.makeMainViewController(coordinator: self)
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
    
    func showNotiDetail(noticeIdentifier: Notice.ID) {
        let vc = dependencies.makeNoticeDetailViewController(
            noticeIdentifier: noticeIdentifier,
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
}
