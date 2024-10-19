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
    
    func makeAccountRecoveryOptionViewController(coordinator: AuthFlowCoordinator) -> CredentialRecoveryOptionsViewController
    
    // Account recovery
    func makeAccountRecoveryViewController(coordinator: AuthFlowCoordinator, item: AccountRecoveryItem) -> AccountRecoveryViewController
    
    // Profile setup
    func makeProfileSetupViewController(coordinator: AuthFlowCoordinator, request: SignupRequest, signupType: SignupType) -> ProfileSetupViewController
}

protocol Coordinator {
    var coordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start(_ arguments: Any?)
    func goBack()
}

extension Coordinator {
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}

protocol AuthFlowCoordinator: Coordinator {
    
    func startMain(isManager: Bool)
    // func showTutorial()
    //
    func showWorkplaceFinder()
    
    // Shared
    func showSMSValidation(item: SMSVerificationItem)
    func showAccountSetup(item: AccountSetupItem, request: SignupRequest)
    func showCompletion(item: CompletionItem)

    // Signin
    func showSingin()
    func showAccountRecoveryOption()
    
    // Sign up
    func showProfileSetup(request: SignupRequest, signupType: SignupType)
    
    // Account recovery
    func showAccountRecovery(item: AccountRecoveryItem)
}

final class DefaultAuthFlowCoordinator: AuthFlowCoordinator {
    
    // MARK: - Dependencies
    
    var navigationController: UINavigationController
    var coordinators: [Coordinator] = []

    private let dependencies: AuthFlowCoordinatorDependencies
    
    // MARK: - Life Cycle Methods
    
    init(
        navigationController: UINavigationController,
        dependencies: AuthFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start(_ arguments: Any?) {
        showSingin()
    }
    
    func startMain(isManager: Bool) {
        for child in coordinators {
            if child is TabBarFlowCoordinator {
                child.start(isManager)
            }
        }
    }
    
    func showWorkplaceFinder() {
        for child in coordinators {
            if let main = child as? TabBarFlowCoordinator {
                main.showWorkplaceFinder()
            }
        }
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
    
    func showProfileSetup(request: SignupRequest, signupType: SignupType) {
        let vc = dependencies.makeProfileSetupViewController(coordinator: self, request: request, signupType: signupType)
        navigationController.setViewControllers([vc], animated: true)
    }
    
    // MARK: - Account Option
    
    func showAccountRecoveryOption() {
        let vc = dependencies.makeAccountRecoveryOptionViewController(coordinator: self)
        let bottomSheet = BottomSheetController(contentViewController: vc)
        navigationController.present(bottomSheet, animated: true)
    }
    
    func showAccountRecovery(item: AccountRecoveryItem) {
        let vc = dependencies.makeAccountRecoveryViewController(coordinator: self, item: item)
        navigationController.pushViewController(vc, animated: true)
    }
}
