//
//  FinderFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 10/20/24.
//

import UIKit

// MARK: - Dependencies

protocol FinderFlowCoordinatorDependencies {
    func makeWorkplaceFinderViewController(coordinator: FinderFlowCoordinator) -> PlaceFinderViewController
    func makeSearchWorkplaceViewController(coordinator: FinderFlowCoordinator) -> PlaceSearchViewController
    func makeWorkplaceDetailsViewController(coordinator: FinderFlowCoordinator, workplaceID: Workplace.ID) -> PlaceDetailsViewController
    func makeAddNewWorkplaceViewController(coordinator: FinderFlowCoordinator) -> PlaceCreationViewController
}

// MARK: - Coordinator

protocol FinderFlowCoordinator: Coordinator {
    func showReminderList()
    func showWorkplaceFinder()
    func showSearchWorkPlace()
    func showWorkplaceDetails(workplaceID: Workplace.ID)
    func showAddNewWorkplace()

    // 일정 생성
    func moveToScheduleCreation()
}

final class DefaultFinderFlowCoordinator: FinderFlowCoordinator {

    weak var parentCoordinator: DefaultTabBarFlowCoordinator?
    var childCoordinators: [any Coordinator] = []
    var nav: UINavigationController = .init()
    private let dependencies: FinderFlowCoordinatorDependencies

    // MARK: - Life Cycle Methods

    init(
        // navigationController: UINavigationController,
        dependencies: FinderFlowCoordinatorDependencies
    ) {
        // self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start(_ arguments: Any?) {
        guard let nav = arguments as? UINavigationController else { return }
        self.nav = nav
        showWorkplaceFinder()
    }

    func showReminderList() {
        parentCoordinator?.showReminderList()
    }

    func showWorkplaceFinder() {
        let vc = dependencies.makeWorkplaceFinderViewController(coordinator: self)
        nav.setViewControllers([vc], animated: false)
    }

    func showSearchWorkPlace() {
        let vc = dependencies.makeSearchWorkplaceViewController(coordinator: self)
        nav.pushViewController(vc, animated: true)
    }

    //    func showWorkplaceList() {
    //        let contentViewController = dependencies.makeWorkplaceListViewController(coordinator: self)
    //        let bottomSheetController = BottomSheetController(contentViewController: contentViewController)
    //        navigationController.present(bottomSheetController, animated: true)
    //    }

    func showWorkplaceDetails(workplaceID: Workplace.ID) {
        let vc = dependencies.makeWorkplaceDetailsViewController(coordinator: self, workplaceID: workplaceID)
        nav.pushViewController(vc, animated: true)
    }

    func showAddNewWorkplace() {
        let vc = dependencies.makeAddNewWorkplaceViewController(coordinator: self)
        nav.pushViewController(vc, animated: true)
    }

    func moveToScheduleCreation() {
        parentCoordinator?.showScheduleCreation()
    }
}
