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
    
    // MARK: - Life Cycle Methods
    
    init(
        navigationController: UINavigationController,
         dependencies: AuthFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        showSingin()
    }
    
    // MARK: - Signin
    
    func showSingin() {
        
    }
        
    // MARK: - Signup
    
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
