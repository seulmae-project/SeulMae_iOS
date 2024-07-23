//
//  MainFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import UIKit

protocol MainFlowCoordinatorDependencies {
    func makeMainViewController(coordinator: MainFlowCoordinator) -> MainViewController
    func makeSearchPlaceViewController(coordinator: MainFlowCoordinator) -> SearchPlaceViewController
    func makeMemberInfoViewController(member: Member, coordinator: MainFlowCoordinator) -> MemberInfoViewController
    func makeNotiListViewController(workplaceIdentifier: Workplace.ID, coordinator: MainFlowCoordinator) -> NotiListViewController
}

protocol MainFlowCoordinator {
    
    func start()
    func showMain()
    func showMemberInfo(member: Member)
    func showNotiList(workplaceIdentifier: Workplace.ID)
    func goBack()
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
    
    func showSearchPlace() {
        let vc = dependencies.makeSearchPlaceViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }

    func showMemberInfo(member: Member) {
        let vc = dependencies.makeMemberInfoViewController(
            member: member,
            coordinator: self
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showNotiList(workplaceIdentifier: Workplace.ID) {
        let vc = dependencies.makeNotiListViewController(
            workplaceIdentifier: workplaceIdentifier,
            coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
}
