//
//  HomeFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 9/9/24.
//

import UIKit

// MARK: - Dependencies

protocol HomeFlowCoordinatorDependencies {
    func makeMemberHomeViewController(coordinator: HomeFlowCoordinator) -> UserHomeViewController
    func makeManagerHomeViewController(coordinator: HomeFlowCoordinator) -> ManagerHomeViewController
    func makeAttHistiesVC(coordinator: HomeFlowCoordinator) -> AttHistoriesViewController

    // bottom modal
    func makeScheduleReminderViewController(coordinator: HomeFlowCoordinator) -> ScheduleReminderViewController
    func makeWorkTimeRecordingViewController(coordinator: HomeFlowCoordinator) -> WorkTimeRecordingViewController
    func makeWorkLogSummaryViewController(coordinator: HomeFlowCoordinator) -> WorkLogViewController
}

protocol HomeFlowCoordinator: Coordinator {

    // Member Logic
    func showMemberHome()

    // Manager Logic
    func showManagerHome()
    func showAttHistories()

    // bottom modal
    func showScheduleReminder()
    func startWorkTimeRecord()
    func showWorkLogSummary()
}

final class DefaultHomeFlowCoordinator: HomeFlowCoordinator {
    
    var childCoordinators = [any Coordinator]()
    lazy var nav = UINavigationController()
    let parentNav: UINavigationController
    private let dependencies: HomeFlowCoordinatorDependencies
    
    // MARK: - Life Cycle Methods
    
    init(
        navigationController: UINavigationController,
        dependencies: HomeFlowCoordinatorDependencies
    ) {
        self.parentNav = navigationController
        self.dependencies = dependencies
    }
    
    func start(_ arguments: Any?) {
        guard let isManager = arguments as? Bool else {
            Swift.fatalError("[Home Flow]: Does not fount arguments")
        }
        
        isManager ? showManagerHome() : showMemberHome()
    }
    
    func showMemberHome() {
        let vc = dependencies.makeMemberHomeViewController(coordinator: self)
        nav.setViewControllers([vc], animated: false)
    }
    
    func showManagerHome() {
        let vc = dependencies.makeManagerHomeViewController(coordinator: self)
        nav.setViewControllers([vc], animated: false)
    }

    func showAttHistories() {
        let vc = dependencies.makeAttHistiesVC(coordinator: self)
        parentNav.pushViewController(vc, animated: true)
    }

    func showScheduleReminder() {
        let vc = dependencies.makeScheduleReminderViewController(coordinator: self)
        let bottomSheet = BottomSheetController(contentViewController: vc)
        bottomSheet.trackingScrollView = vc.scrollView
        nav.present(bottomSheet, animated: true)
    }
    
    func startWorkTimeRecord() {
        let vc = dependencies.makeWorkTimeRecordingViewController(coordinator: self)
        guard let parentVC = nav.topViewController?.presentedViewController as? BottomSheetController else {
            return
        }
        parentVC.addChild(vc)
        parentVC.view.addSubview(vc.view)
        vc.didMove(toParent: parentVC)
    }
    
    func showWorkLogSummary() {
        let vc = dependencies.makeWorkLogSummaryViewController(coordinator: self)
        guard let parentVC = nav.topViewController?.presentedViewController as? BottomSheetController else {
            return
        }
        parentVC.addChild(vc)
        parentVC.view.addSubview(vc.view)
        vc.didMove(toParent: parentVC)
    }
}
