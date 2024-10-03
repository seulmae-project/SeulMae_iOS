//
//  MainTabBarController.swift
//  SeulMae
//
//  Created by 조기열 on 9/5/24.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override var viewControllers: [UIViewController]? {
        didSet {
            setupTabBar()
        }
    }
    
    private let mainCoordinator: MainFlowCoordinator
    
    init(viewContollers: [UIViewController], mainCoordinator: MainFlowCoordinator) {
        self.mainCoordinator = mainCoordinator
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewContollers
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightNotiBarButton = UIBarButtonItem(image: .bell, style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = rightNotiBarButton
        
        let showNotis = rightNotiBarButton.rx.tap.asSignal()
        Task {
            for await _ in showNotis.values {
                mainCoordinator.showNotiList()
            }
        }
    }
    
    private func setupTabBar() {
        guard let home = viewControllers?[0],
              let workplace = viewControllers?[1],
              let setting = viewControllers?[2] else { return }
        tabBar.tintColor = .primary
        home.tabBarItem = UITabBarItem(title: "메인", image: .calendarDots, tag: 0)
        workplace.tabBarItem = UITabBarItem(title: "근무지", image: .house, tag: 1)
        setting.tabBarItem = UITabBarItem(title: "설정", image: .gear, tag: 2)
    }
}
