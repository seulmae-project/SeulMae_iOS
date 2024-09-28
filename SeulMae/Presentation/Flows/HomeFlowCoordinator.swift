//
//  HomeFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 9/9/24.
//

import UIKit

protocol HomeFlowCoordinatorDependencies {
    func makeUserHomeViewController(coordinator: HomeFlowCoordinator) -> UserHomeViewController
    func makeNotiListViewController(coordinator: HomeFlowCoordinator) -> NotiListViewController
    
    // bottom modal
    func makeScheduleReminderViewController(coordinator: HomeFlowCoordinator) -> ScheduleReminderViewController
    func makeWorkTimeRecordingViewController(coordinator: HomeFlowCoordinator) -> WorkRecordViewController
}

protocol HomeFlowCoordinator: Coordinator {
    func start()
    func goBack()
    
    func showUserHome()
    func showManagerHome()
    func showNotiList()
    
    func showScheduleReminder()
    func startWorkTimeRecord()
}

final class DefaultHomeFlowCoordinator: HomeFlowCoordinator {
    
    var coordinators = [any Coordinator]()
    lazy var navigationController = UINavigationController()
    
    // MARK: - Dependency
    
    private let dependencies: HomeFlowCoordinatorDependencies
    
    // MARK: - Life Cycle Methods
    
    init(
        // navigationController: UINavigationController,
        dependencies: HomeFlowCoordinatorDependencies
    ) {
        // self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        showUserHome()
    }
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
    
    func showUserHome() {
        let vc = dependencies.makeUserHomeViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func showManagerHome() {
        
    }
    
    func showNotiList() {
        let vc = dependencies.makeNotiListViewController(
            coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showScheduleReminder() {
        let vc = dependencies.makeScheduleReminderViewController(coordinator: self)
        let bottomSheet =  BottomSheetController(contentViewController: vc)
        navigationController.present(bottomSheet, animated: true)
    }
    
    func startWorkTimeRecord() {
        let vc = dependencies.makeWorkTimeRecordingViewController(coordinator: self)
        guard let parentVC = navigationController.topViewController as? ScheduleReminderViewController else { Swift.print("???????"); return }
        parentVC.addChild(vc)
        parentVC.view.addSubview(vc.view)
        vc.didMove(toParent: parentVC)
    }
}
