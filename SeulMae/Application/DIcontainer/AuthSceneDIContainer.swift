//
//  AuthSceneDIContainer.swift
//  SeulMae
//
//  Created by 조기열 on 6/18/24.
//

import UIKit.UINavigationController

final class AuthSceneDIContainer {
    
    struct Dependencies {
        let authNetworking: AuthNetworking
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeAuthUseCase() -> AuthUseCase {
        return DefaultAuthUseCase(authRepository: makeAuthRepository())
    }
    
    private func makeAuthRepository() -> AuthRepository {
        return DefaultAuthRepository(network: dependencies.authNetworking)
    }
    
    // MARK: - Flow Coordinators
    
    func makeAuthFlowCoordinator(
        navigationController: UINavigationController,
        mainFlowCoordinator: MainFlowCoordinator
    ) -> AuthFlowCoordinator {
        return DefaultAuthFlowCoordinator(
            navigationController: navigationController,
            dependencies: self,
            mainFlowCoordinator: mainFlowCoordinator
        )
    }
}

extension AuthSceneDIContainer: AuthFlowCoordinatorDependencies {
    
    // MARK: - Signin Flow
    
    func makeSigninViewController(coordinator: any AuthFlowCoordinator) -> SigninViewController {
        return .create(viewModel: makeSigninViewModel(coordinator: coordinator))
    }
    
    private func makeSigninViewModel(coordinator: AuthFlowCoordinator) -> SigninViewModel {
        return SigninViewModel(
            dependency: (
                coordinator: coordinator,
                authUseCase: makeAuthUseCase(),
                validationService: DefaultValidationService.shared,
                wireframe: DefaultWireframe()
            )
        )
    }
    
    // MARK: - Signup Flow
    
    func makePhoneVerificationViewController(coordinator: any AuthFlowCoordinator) -> PhoneVerificationViewController {
        return .create(viewModel: makePhoneVerificationViewModel(coordinator: coordinator))
    }
    
    private func makePhoneVerificationViewModel(coordinator: AuthFlowCoordinator) -> PhoneVerificationViewModel {
        return PhoneVerificationViewModel(
            dependency: (
                coordinator: coordinator,
                authUseCase: makeAuthUseCase(),
                validationService: DefaultValidationService.shared,
                wireframe: DefaultWireframe()
            )
        )
    }
    
    func makeAccountSetupViewController(coordinator: any AuthFlowCoordinator,
                                        request: SignupRequest
    ) -> AccountSetupViewController {
        return .create(viewModel: makeAccountSetupViewModel(coordinator: coordinator, request: request))
    }
    
    private func makeAccountSetupViewModel(coordinator: AuthFlowCoordinator,
                                           request: SignupRequest
    ) -> AccountSetupViewModel {
        return AccountSetupViewModel(
            dependency: (
                coordinator: coordinator,
                authUseCase: makeAuthUseCase(),
                validationService: DefaultValidationService.shared,
                wireframe: DefaultWireframe(),
                request: request
            )
        )
    }
    
    func makeProfileSetupViewController(coordinator: any AuthFlowCoordinator, 
                                        request: SignupRequest) -> ProfileSetupViewController {
        return .create(viewModel: makeProfileSetupViewModel(coordinator: coordinator, request: request))
    }
    
    private func makeProfileSetupViewModel(coordinator: AuthFlowCoordinator, 
                                           request: SignupRequest) -> ProfileSetupViewModel {
        return ProfileSetupViewModel(
            dependency: (
                coordinator: coordinator,
                authUseCase: makeAuthUseCase(),
                validationService: DefaultValidationService.shared,
                wireframe: DefaultWireframe(),
                request: request
            )
        )
    }
    
    func makeSignupCompletionViewController(coordinator: any AuthFlowCoordinator) -> SignupCompletionViewController {
        return .create(viewModel: makeSignupCompletionViewModel(coordinator: coordinator))
    }
    
    private func makeSignupCompletionViewModel(coordinator: AuthFlowCoordinator
    ) -> SignupCompletionViewModel {
        return SignupCompletionViewModel(
            dependency: (
                coordinator: coordinator,
                authUseCase: makeAuthUseCase(),
                validationService: DefaultValidationService.shared,
                wireframe: DefaultWireframe()
            )
        )
    }
}
