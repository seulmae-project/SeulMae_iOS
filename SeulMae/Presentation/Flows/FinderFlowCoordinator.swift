//
//  FinderFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 10/20/24.
//

import UIKit

// MARK: - Dependencies

protocol FinderFlowCoordinatorDependencies {
    func makeWorkplaceFinderViewController(coordinator: FinderFlowCoordinator) -> WorkplaceFinderViewController
    func makeSearchWorkplaceViewController(coordinator: FinderFlowCoordinator) -> SearchWorkplaceViewController
    func makeWorkplaceDetailsViewController(coordinator: FinderFlowCoordinator, workplaceID: Workplace.ID) -> WorkplaceDetailsViewController
    func makeAddNewWorkplaceViewController(coordinator: FinderFlowCoordinator) -> AddNewWorkplaceViewController
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
    var navigationController: UINavigationController = .init()
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
        self.navigationController = nav
        showWorkplaceFinder()
    }

    func showReminderList() {
        parentCoordinator?.showReminderList()
    }

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

    func moveToScheduleCreation() {
        parentCoordinator?.showScheduleCreation()
    }
}
