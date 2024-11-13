//
//  AuthFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 6/11/24.
//

import UIKit

protocol AuthFlowCoordinatorDependencies {
    func makeSMSValidationVC(coordinator: AuthFlowCoordinator, type: SMSVerificationType) -> SMSVerificationViewController
    func makeIdRecoveryVC(coordinator: AuthFlowCoordinator, result: SMSVerificationResult) -> IdRecoveryViewController
    func makePwRecoveryVC(coordinator: AuthFlowCoordinator, result: SMSVerificationResult) -> PwRecoveryViewController
    func makeAccountSetupVC(coordinator: AuthFlowCoordinator, userInfo: UserInfo) -> AccountSetupViewController

    // (Shared) Completion
    func makeCompletionVC(coordinator: AuthFlowCoordinator, type: CompletionType) -> CompletionViewController
    
    // Sign in
    func makeSigninViewController(coordinator: AuthFlowCoordinator) -> SigninViewController
    
    func makeAccountRecoveryOptionViewController(coordinator: AuthFlowCoordinator) -> CredentialRecoveryOptionsViewController
    
    // Account recovery
    func makeAccountRecoveryViewController(coordinator: AuthFlowCoordinator, item: AccountRecoveryItem) -> AccountRecoveryViewController
    
    // Profile setup
    func makeProfileSetupViewController(coordinator: AuthFlowCoordinator, request: UserInfo, signupType: SignupType) -> ProfileSetupViewController
}

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var nav: UINavigationController { get set }
    func start(_ arguments: Any?)
    func goBack()
}

extension Coordinator {
    func goBack() {
        nav.popViewController(animated: true)
    }
}

protocol AuthFlowCoordinator: Coordinator {
    
    func startMain(isManager: Bool)

    func showWorkplaceFinder()


    func showSignin()
    func showSMSValidation(type: SMSVerificationType)
    func showIdRecovery(result: SMSVerificationResult)
    func showPwRecovery(result: SMSVerificationResult)

    func showAccountSetup(userinfo: UserInfo)
    func showCompletion(tpye: CompletionType)

    // 휴지통
    func showAccountRecoveryOption()
    
    // Sign up
    func showProfileSetup(request: UserInfo, signupType: SignupType)
    
    // Account recovery
    func showAccountRecovery(item: AccountRecoveryItem)
}

final class DefaultAuthFlowCoordinator: AuthFlowCoordinator {
    
    // MARK: - Dependencies
    var nav: UINavigationController
    var childCoordinators: [any Coordinator] = []

    private let dependencies: AuthFlowCoordinatorDependencies
    
    // MARK: - Life Cycle Methods
    
    init(
        navigationController: UINavigationController,
        dependencies: AuthFlowCoordinatorDependencies
    ) {
        self.nav = navigationController
        self.dependencies = dependencies
    }
    
    func start(_ arguments: Any?) {
        showSignin()
    }
    
    func startMain(isManager: Bool) {
        for child in childCoordinators {
            if child is TabBarFlowCoordinator {
                child.start(isManager)
            }
        }
    }
    
    func showWorkplaceFinder() {
        for child in childCoordinators {
            if let main = child as? TabBarFlowCoordinator {
                main.showFinder()
            }
        }
    }

    // MARK: - Signin

    func showSignin() {
        let vc = dependencies.makeSigninViewController(coordinator: self)
        nav.setViewControllers([vc], animated: false)
    }

    // MARK: - SMS Validation

    func showSMSValidation(type: SMSVerificationType) {
        let signinVC = dependencies.makeSigninViewController(coordinator: self)
        let validationVC = dependencies.makeSMSValidationVC(coordinator: self, type: type)
        nav.setViewControllers([signinVC, validationVC], animated: false)
    }

    // MARK: - Id Recovery

    func showIdRecovery(result: SMSVerificationResult) {
        let vc = dependencies.makeIdRecoveryVC(coordinator: self, result: result)
        nav.pushViewController(vc, animated: true)
    }

    // MARK: - Pw Recovery

    func showPwRecovery(result: SMSVerificationResult) {
        let vc = dependencies.makePwRecoveryVC(coordinator: self, result: result)
        nav.pushViewController(vc, animated: true)
    }

    // MARK: - Completion

    func showCompletion(tpye: CompletionType) {
        let vc = dependencies.makeCompletionVC(coordinator: self, type: tpye)
        nav.pushViewController(vc, animated: true)
    }
    

    
    // MARK: - Signup
    
    func showAccountSetup(userinfo: UserInfo) {
        let vc = dependencies.makeAccountSetupVC(coordinator: self, userInfo: userinfo)
        nav.pushViewController(vc, animated: true)
    }
    
    func showProfileSetup(request: UserInfo, signupType: SignupType) {
        let vc = dependencies.makeProfileSetupViewController(coordinator: self, request: request, signupType: signupType)
        nav.setViewControllers([vc], animated: true)
    }
    
    // MARK: - Account Option
    
    func showAccountRecoveryOption() {
        let vc = dependencies.makeAccountRecoveryOptionViewController(coordinator: self)
        let bottomSheet = BottomSheetController(contentViewController: vc)
        nav.present(bottomSheet, animated: true)
    }
    
    func showAccountRecovery(item: AccountRecoveryItem) {
        let vc = dependencies.makeAccountRecoveryViewController(coordinator: self, item: item)
        nav.pushViewController(vc, animated: true)
    }
}
