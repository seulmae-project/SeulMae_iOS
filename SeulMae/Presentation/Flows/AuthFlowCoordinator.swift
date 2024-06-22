//
//  AuthFlowCoordinator.swift
//  SeulMae
//
//  Created by 조기열 on 6/11/24.
//

import UIKit

protocol AuthFlowCoordinatorDependencies {
    func makeSigninViewController(coordinator: AuthFlowCoordinator) -> SigninViewController
    func makePhoneVerificationViewController(coordinator: AuthFlowCoordinator) -> PhoneVerificationViewController
    func makeAccountSetupViewController(coordinator: AuthFlowCoordinator) -> AccountSetupViewController
    func makeProfileSetupViewController(coordinator: AuthFlowCoordinator) -> ProfileSetupViewController
    func makeSignupCompletionViewController(coordinator: AuthFlowCoordinator) -> SignupCompletionViewController
}

protocol AuthFlowCoordinator {
    
    func start()
    func startMain()
    
    /// - Tag: Signin
    func showSingin()
    
    /// - Tag: Signup
    func showPhoneVerification()
    func showAccountSetup()
    func showProfileSetup()
    func showSignupCompletion()
    
    /// - Tag: Account Service
    func showPhoneVerificationForEmailRecovery()
    func showEmailRecovery()
    func showEmailRecoveryCompletion()
    func showPhoneVerificationForPasswordRecovery()
    func showPasswordRecovery()
    func showPasswordRecoveryCompletion()
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
        showSingin()
    }
    
    func startMain() {
        mainFlowCoordinator.showMain()
    }
    
    // MARK: - Signin
    
    func showSingin() {
        let vc = dependencies.makeSigninViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    // MARK: - Signup
    
    func showPhoneVerification() {
        let vc = dependencies.makePhoneVerificationViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: false)
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
    
    // MARK: - Account Sevice
    
    func showPhoneVerificationForEmailRecovery() {
        
    }
    
    func showEmailRecovery() {
        
    }
    
    func showEmailRecoveryCompletion() {
        
    }
    
    func showPhoneVerificationForPasswordRecovery() {
        
    }
    
    func showPasswordRecovery() {
        
    }
    
    func showPasswordRecoveryCompletion() {
        
    }
}
