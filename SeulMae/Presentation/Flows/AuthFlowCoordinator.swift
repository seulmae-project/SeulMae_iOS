//
//  AuthFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 6/11/24.
//

import UIKit

protocol AuthFlowCoordinatorDependencies {
    // (Shared) SMS validation
    func makeSMSValidationViewController(coordinator: AuthFlowCoordinator, item: SMSVerificationItem) -> SMSVerificationViewController
    
    // (Shared) Account setup
    func makeAccountSetupViewController(coordinator: AuthFlowCoordinator,
        item: AccountSetupItem, request: SignupRequest) -> AccountSetupViewController
    
    // (Shared) Completion
    func makeCompletionViewController(coordinator: AuthFlowCoordinator, item: CompletionItem) -> CompletionViewController
    
    // Sign in
    func makeSigninViewController(coordinator: AuthFlowCoordinator) -> SigninViewController
    
    // Account recovery
    func makeAccountRecoveryViewController(coordinator: AuthFlowCoordinator, item: AccountRecoveryItem) -> AccountRecoveryViewController
    
    // Profile setup
    func makeProfileSetupViewController(coordinator: AuthFlowCoordinator, request: SignupRequest) -> ProfileSetupViewController
}

protocol AuthFlowCoordinator {
    
    func start()
    func startMain()
    // func showTutorial()
    //
    func showSearchWorkplace()
    
    // Shared
    func showSMSValidation(item: SMSVerificationItem)
    func showAccountSetup(item: AccountSetupItem, request: SignupRequest)
    func showCompletion(item: CompletionItem)

    // Signin
    func showSingin()
    
    // Sign up
    func showProfileSetup(request: SignupRequest)
    
    // Account recovery
    func showAccountRecovery(item: AccountRecoveryItem)
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
        
        // showSearchWorkplace()
        showSingin()
    }
    
    func startMain() {
        mainFlowCoordinator.showMain()
    }
    
    func showSearchWorkplace() {
        mainFlowCoordinator.showWorkplaceFinder()
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
    
    func showAccountRecovery(item: AccountRecoveryItem) {
        let vc = dependencies.makeAccountRecoveryViewController(coordinator: self, item: item)
        navigationController.pushViewController(vc, animated: true)
    }
}
