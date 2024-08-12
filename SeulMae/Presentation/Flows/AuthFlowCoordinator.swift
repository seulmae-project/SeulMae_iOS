//
//  AuthFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 6/11/24.
//

import UIKit

protocol AuthFlowCoordinatorDependencies {
    func makeSigninViewController(coordinator: AuthFlowCoordinator) -> SigninViewController
    func makeSMSValidationViewController(coordinator: AuthFlowCoordinator, item: SMSVerificationItem) -> SMSVerificationViewController
    func makeAccountSetupViewController(
        coordinator: AuthFlowCoordinator,
        item: AccountSetupItem,
        request: SignupRequest
    ) -> AccountSetupViewController
    func makeProfileSetupViewController(coordinator: AuthFlowCoordinator, request: SignupRequest) -> ProfileSetupViewController
    func makeCompletionViewController(
        coordinator: AuthFlowCoordinator,
        item: CompletionItem
    ) -> CompletionViewController
    func makeIDRecoveryViewController(coordinator: AuthFlowCoordinator) -> IDRecoveryViewController
}

protocol AuthFlowCoordinator {
    
    func start()
    func startMain()
    
    /// - Tag: Common
    func showSMSValidation(item: SMSVerificationItem)
    func showCompletion(item: CompletionItem)

    /// - Tag: Signin
    func showSingin()
    
    /// - Tag: Signup
    func showAccountSetup(item: AccountSetupItem, request: SignupRequest)
    func showProfileSetup(request: SignupRequest)
    
    /// - Tag: Account Service
    func showAccountIDRecovery()
}

final class DefaultAuthFlowCoordinator: AuthFlowCoordinator {
    
    // MARK: - Dependency
    
    private let navigationController: UINavigationController
    
    private let dependencies: AuthFlowCoordinatorDependencies
    
    private let mainFlowCoordinator: MainFlowCoordinator
    
    // MARK: - Life Cycle Methods
    
    init(
        navigationController: UINavigationController,
        dependencies: AuthFlowCoordinatorDependencies,
        mainFlowCoordinator: MainFlowCoordinator
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.mainFlowCoordinator = mainFlowCoordinator
    }
    
    func start() {
//        showProfileSetup(request: SignupRequest())
        showCompletion(item: .signup(username: "조기열"))
        // showSingin()
    }
    
    func startMain() {
        mainFlowCoordinator.showMain()
    }
    
    // MARK: - Common
    
    func showSMSValidation(item: SMSVerificationItem) {
        let vc = dependencies.makeSMSValidationViewController(coordinator: self, item: item)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showCompletion(item: CompletionItem) {
        let vc = dependencies.makeCompletionViewController(coordinator: self, item: item)
        navigationController.pushViewController(vc, animated: true)
    }
    
    // MARK: - Signin
    
    func showSingin() {
        let vc = dependencies.makeSigninViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    // MARK: - Signup
    
    func showAccountSetup(item: AccountSetupItem, request: SignupRequest) {
        let vc = dependencies.makeAccountSetupViewController(coordinator: self, item: item, request: request)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showProfileSetup(request: SignupRequest) {
        let vc = dependencies.makeProfileSetupViewController(coordinator: self, request: request)
        navigationController.setViewControllers([vc], animated: true)
        // pushViewController
    }
    
    // MARK: - Account Sevice
    
    func showAccountIDRecovery() {
        let vc = dependencies.makeIDRecoveryViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
}
