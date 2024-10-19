//
//  MainFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import UIKit

protocol MainFlowCoordinatorDependencies {
    
  
    //    func makeMainViewController(coordinator: MainFlowCoordinator) -> MainViewController
    //    func makeMemberInfoViewController(member: Member, coordinator: MainFlowCoordinator) -> MemberInfoViewController
    //    func makeWorkplaceListViewController(coordinator: MainFlowCoordinator) -> WorkplacePlaceListViewController
    
    // MARK: Workplace Flow Dependencies
    func makeWorkplaceFinderViewController(coordinator: MainFlowCoordinator) -> WorkplaceFinderViewController
    func makeSearchWorkplaceViewController(coordinator: MainFlowCoordinator) -> SearchWorkplaceViewController
    func makeWorkplaceDetailsViewController(coordinator: MainFlowCoordinator, workplaceID: Workplace.ID) -> WorkplaceDetailsViewController
    func makeAddNewWorkplaceViewController(coordinator: MainFlowCoordinator) -> AddNewWorkplaceViewController
    
    // MARK: - Announce Flow Dependencies
    //    func makeAnnounceViewController(coordinator: MainFlowCoordinator) -> AnnounceViewController
    //    func makeAnnounceDetailViewController(coordinator: MainFlowCoordinator, announceId: Announce.ID?) -> AnnounceDetailViewController
    
    // MARK: - Setting
    //    func makeWorkplaceViewController(coordinator: MainFlowCoordinator) -> WorkplaceViewController
    //    func makeSettingViewController(coordinator: MainFlowCoordinator) -> SettingViewController
}

protocol MainFlowCoordinator: Coordinator {
    
    
    
    
    func showWorkplaceFinder()
    func showSearchWorkPlace()
    func showWorkplaceDetails(workplaceID: Workplace.ID)
    func showAddNewWorkplace()
}

final class DefaultMainFlowCoordinator: MainFlowCoordinator {
    
    var coordinators: [any Coordinator] = []
    
    // MARK: - Dependencies
    
    var navigationController: UINavigationController
    private let dependencies: MainFlowCoordinatorDependencies
    
    // MARK: - Life Cycle Methods
    
    init(
        navigationController: UINavigationController,
        dependencies: MainFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start(_ arguments: Any?) {
        guard let isManager = arguments as? Bool else {
            Swift.fatalError("[Main Flow]: Does not fount arguments")
            // return
        }
        
        showMain(isManager: isManager)
    }
    
    func showMain(isManager: Bool) {
        coordinators.forEach { $0.start(isManager) }
        let viewControllers = coordinators.map { $0.navigationController }
        let vc = MainTabBarController(viewContollers: viewControllers, mainCoordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }
    

    
    // MARK: - Workplace Flow
    
    func showWorkplaceFinder() {
        let vc = dependencies.makeWorkplaceFinderViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func showSearchWorkPlace() {
        let vc = dependencies.makeSearchWorkplaceViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    //    func showWorkplaceList() {
    //        let contentViewController = dependencies.makeWorkplaceListViewController(coordinator: self)
    //        let bottomSheetController = BottomSheetController(contentViewController: contentViewController)
    //        navigationController.present(bottomSheetController, animated: true)
    //    }
    
    func showWorkplaceDetails(workplaceID: Workplace.ID) {
        let vc = dependencies.makeWorkplaceDetailsViewController(coordinator: self, workplaceID: workplaceID)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showAddNewWorkplace() {
        let vc = dependencies.makeAddNewWorkplaceViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
}
