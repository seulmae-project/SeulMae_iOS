//
//  AuthFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 6/11/24.
//

import UIKit

protocol AuthFlowCoordinatorDependencies {
    func makePhoneVerificationViewController(coordinator: AuthFlowCoordinator) -> PhoneVerificationViewController
    func makeAccountSetupViewController(coordinator: AuthFlowCoordinator) -> AccountSetupViewController
    func makeProfileSetupViewController(coordinator: AuthFlowCoordinator) -> ProfileSetupViewController
    func makeSignupCompletionViewController(coordinator: AuthFlowCoordinator) -> SignupCompletionViewController
}

protocol AuthFlowCoordinator {
    func start()
    func showPhoneVerification()
    func showAccountSetup()
    func showProfileSetup()
    func showSignupCompletion()
}

final class DefaultAuthFlowCoordinator: AuthFlowCoordinator {

    // MARK: - Dependency
    
    private let navigationController: UINavigationController
    private let dependencies: AuthFlowCoordinatorDependencies
    
    // MARK: - Life Cycle Methods
    
    init(
        navigationController: UINavigationController,
         dependencies: AuthFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        showPhoneVerification()
    }
    
    func showPhoneVerification() {
        let vc = dependencies.makePhoneVerificationViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func showAccountSetup() {
        let vc = dependencies.makeAccountSetupViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showProfileSetup() {
        let vc = dependencies.makeProfileSetupViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showSignupCompletion() {
        let vc = dependencies.makeSignupCompletionViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
}
