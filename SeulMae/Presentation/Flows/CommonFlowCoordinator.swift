//
//  CommonFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 10/20/24.
//

import UIKit

// MARK: - Dependencies

protocol CommonFlowCoordinatorDependencies {
    func makeReminderListViewController(coordinator: CommonFlowCoordinator) -> ReminderListViewController
}

protocol CommonFlowCoordinator: Coordinator {
    func showReminders()
}

final class DefaultCommonFlowCoordinator: CommonFlowCoordinator {

    var childCoordinators = [any Coordinator]()
    lazy var nav = UINavigationController()
    private let dependencies: CommonFlowCoordinatorDependencies

    // MARK: - Life Cycle Methods

    init(
        // navigationController: UINavigationController,
        dependencies: CommonFlowCoordinatorDependencies
    ) {
        // self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start(_ arguments: Any?) {
        guard let nav = arguments as? UINavigationController else { return }
        self.nav = nav
        showReminders()
    }

    func showReminders() {
        let vc = dependencies.makeReminderListViewController(coordinator: self)
        nav.pushViewController(vc, animated: true)
    }
}
