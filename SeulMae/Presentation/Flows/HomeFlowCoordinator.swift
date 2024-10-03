//
//  HomeFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 9/9/24.
//

import UIKit

protocol HomeFlowCoordinatorDependencies {
    func makeMemberHomeViewController(coordinator: HomeFlowCoordinator) -> UserHomeViewController
    func makeManagerHomeViewController(coordinator: HomeFlowCoordinator) -> ManagerHomeViewController
    
    func makeNotiListViewController(coordinator: HomeFlowCoordinator) -> NotiListViewController
    
    // bottom modal
    func makeScheduleReminderViewController(coordinator: HomeFlowCoordinator) -> ScheduleReminderViewController
    func makeWorkTimeRecordingViewController(coordinator: HomeFlowCoordinator) -> WorkTimeRecordingViewController
}

protocol HomeFlowCoordinator: Coordinator {
    func showMemberHome()
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
    
    func start(_ arguments: Any?) {
        guard let isManager = arguments as? Bool else {
            Swift.fatalError("[Home Flow]: Does not fount arguments")
            // return
        }
        
        if isManager {
            showManagerHome()
        } else {
            showMemberHome()
        }
    }
    
    func showMemberHome() {
        let vc = dependencies.makeMemberHomeViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func showManagerHome() {
        let vc = dependencies.makeManagerHomeViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
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
        guard let parentVC = navigationController.topViewController?.presentedViewController as? BottomSheetController else {
            return
        }
        parentVC.addChild(vc)
        parentVC.view.addSubview(vc.view)
        vc.didMove(toParent: parentVC)
    }
}
