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
                validationService: DefaultValidationService(),
                wireframe: DefaultWireframe()
            )
        )
    }
    
    // MARK: - Signup Flow
    
    func makePhoneVerificationViewController(coordinator: any AuthFlowCoordinator) -> PhoneVerificationViewController {
        return .create(viewModel: makePhoneVerificationViewModel(coordinator: coordinator))
    }
    
    private func makePhoneVerificationViewModel(coordinator: AuthFlowCoordinator
    ) -> PhoneVerificationViewModel {
        return PhoneVerificationViewModel(
            dependency: (
                coordinator: coordinator,
                authUseCase: makeAuthUseCase(),
                validationService: DefaultValidationService(),
                wireframe: DefaultWireframe()
            )
        )
    }
    
    func makeAccountSetupViewController(coordinator: any AuthFlowCoordinator
    ) -> AccountSetupViewController {
        return .create(viewModel: makeAccountSetupViewModel(coordinator: coordinator))
    }
    
    private func makeAccountSetupViewModel(coordinator: AuthFlowCoordinator
    ) -> AccountSetupViewModel {
        return AccountSetupViewModel(
//            dependency: (
//                authUseCase: makeMapUseCase(),
//                coordinator: coordinator
//            )
        )
    }
    
    func makeProfileSetupViewController(coordinator: any AuthFlowCoordinator) -> ProfileSetupViewController {
        return .create(viewModel: makeProfileSetupViewModel(coordinator: coordinator))
    }
    
    private func makeProfileSetupViewModel(coordinator: AuthFlowCoordinator
    ) -> ProfileSetupViewModel {
        return ProfileSetupViewModel(
//            dependency: (
//                authUseCase: makeMapUseCase(),
//                coordinator: coordinator
//            )
        )
    }
    
    func makeSignupCompletionViewController(coordinator: any AuthFlowCoordinator) -> SignupCompletionViewController {
        return .create(viewModel: makeSignupCompletionViewModel(coordinator: coordinator))
    }
    
    private func makeSignupCompletionViewModel(coordinator: AuthFlowCoordinator
    ) -> SignupCompletionViewModel {
        return SignupCompletionViewModel(
//            dependency: (
//                authUseCase: makeMapUseCase(),
//                coordinator: coordinator
//            )
        )
    }
}
