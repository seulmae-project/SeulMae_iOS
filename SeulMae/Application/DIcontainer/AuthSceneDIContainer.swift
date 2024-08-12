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
        item: SMSVerificationItem
    ) -> SMSVerificationViewController {
        return .create(viewModel: makeSMSValidationViewModel(coordinator: coordinator, item: item))
    }
    
    private func makeSMSValidationViewModel(
        coordinator: AuthFlowCoordinator,
        item: SMSVerificationItem
    ) -> SMSVerificationViewModel {
        return SMSVerificationViewModel(
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
    
    func makeAccountSetupViewController(
        coordinator: any AuthFlowCoordinator,
        item: AccountSetupItem,
        request: SignupRequest
    ) -> AccountSetupViewController {
        return .create(
            viewModel: makeAccountSetupViewModel(
                coordinator: coordinator,
                item: item,
                request: request
            )
        )
    }
    
    private func makeAccountSetupViewModel(
        coordinator: AuthFlowCoordinator,
        item: AccountSetupItem,
        request: SignupRequest
    ) -> AccountSetupViewModel {
        return AccountSetupViewModel(
            dependencies: (
                coordinator: coordinator,
                authUseCase: makeAuthUseCase(),
                validationService: DefaultValidationService.shared,
                wireframe: DefaultWireframe(),
                item: item,
                request: request
            )
        )
    }
    
    func makeProfileSetupViewController(
        coordinator: any AuthFlowCoordinator,
        request: SignupRequest
    ) -> ProfileSetupViewController {
        return .create(
            viewModel: makeProfileSetupViewModel(
                coordinator: coordinator,
                request: request
            )
        )
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
    
    // MARK: - ID Recovery
    
    func makeAccountRecoveryViewController(
        coordinator: any AuthFlowCoordinator,
        item: AccountRecoveryItem
    ) -> AccountRecoveryViewController {
        return .init(
            viewModel: makeAccountRecoveryViewModel(
                coordinator: coordinator,
                item: item
            )
        )
    }
    
    private func makeAccountRecoveryViewModel(
        coordinator: AuthFlowCoordinator,
        item: AccountRecoveryItem
    ) -> AccountRecoveryViewModel {
        return AccountRecoveryViewModel(
            dependency: (
                coordinator: coordinator,
                authUseCase: makeAuthUseCase(),
                wireframe: DefaultWireframe(),
                item: item
            )
        )
    }
}
