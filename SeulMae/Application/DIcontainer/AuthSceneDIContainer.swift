//
//  AuthSceneDIContainer.swift
//  SeulMae
//
//  Created by 조기열 on 6/18/24.
//

import UIKit

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
    
    // MARK: - Common
    
    func makeSMSValidationViewController(
        coordinator: any AuthFlowCoordinator,
        item: SMSValidationItem
    ) -> SMSValidationViewController {
        return .create(viewModel: makeSMSValidationViewModel(coordinator: coordinator, item: item))
    }
    
    private func makeSMSValidationViewModel(
        coordinator: AuthFlowCoordinator,
        item: SMSValidationItem
    ) -> SMSValidationViewModel {
        return SMSValidationViewModel(
            dependency: (
                coordinator: coordinator,
                authUseCase: makeAuthUseCase(),
                validationService: DefaultValidationService.shared,
                wireframe: DefaultWireframe(),
                item: item
            )
        )
    }
    
    func makeCompletionViewController(
        coordinator: any AuthFlowCoordinator,
        item: CompletionItem
    ) -> CompletionViewController {
        return .create(viewModel: makeCompletionViewModel(coordinator: coordinator, item: item))
    }
    
    private func makeCompletionViewModel(
        coordinator: AuthFlowCoordinator,
        item: CompletionItem
    ) -> CompletionViewModel {
        return CompletionViewModel(
            dependency: (
                coordinator: coordinator,
                item: item
            )
        )
    }
    
    // MARK: - Signin Flow
    
    func makeSigninViewController(
        coordinator: any AuthFlowCoordinator
    ) -> SigninViewController {
        return .create(viewModel: makeSigninViewModel(coordinator: coordinator))
    }
    
    private func makeSigninViewModel(
        coordinator: AuthFlowCoordinator
    ) -> SigninViewModel {
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
    
    func makeAccountSetupViewController(coordinator: any AuthFlowCoordinator,
                                        request: SignupRequest
    ) -> AccountSetupViewController {
        return .create(viewModel: makeAccountSetupViewModel(coordinator: coordinator, request: request))
    }
    
    private func makeAccountSetupViewModel(
        coordinator: AuthFlowCoordinator,
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
    
    func makeProfileSetupViewController(
        coordinator: any AuthFlowCoordinator,
        request: SignupRequest
    ) -> ProfileSetupViewController {
        return .create(viewModel: makeProfileSetupViewModel(coordinator: coordinator, request: request))
    }
    
    private func makeProfileSetupViewModel(
        coordinator: AuthFlowCoordinator,
        request: SignupRequest
    ) -> ProfileSetupViewModel {
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
    
    // MARK: - Account ID Recovery
    
    func makeAccountIDRecoveryViewController(
        coordinator: any AuthFlowCoordinator
    ) -> AccountIDRecoveryViewController {
        return .create(viewModel: makeAccountIDRecoveryViewModel(coordinator: coordinator))
    }
    
    private func makeAccountIDRecoveryViewModel(
        coordinator: AuthFlowCoordinator
    ) -> AccountIDRecoveryViewModel {
        return AccountIDRecoveryViewModel(
            dependency: (
                coordinator: coordinator,
                authUseCase: makeAuthUseCase(),
                validationService: DefaultValidationService.shared,
                wireframe: DefaultWireframe()
            )
        )
    }
}
