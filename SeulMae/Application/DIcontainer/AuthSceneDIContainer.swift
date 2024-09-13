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
    
    // MARK: - Private
    
    private func makeAuthUseCase() -> AuthUseCase {
        return DefaultAuthUseCase(
            authRepository: makeAuthRepository(),
            workplaceRepository: makeWorkplaceRepository()
        )
    }
    
    private func makeAuthRepository() -> AuthRepository {
        return DefaultAuthRepository(network: dependencies.authNetworking)
    }
    
    // MARK: - Coordinator
    
    func makeAuthFlowCoordinator(
        navigationController: UINavigationController
    ) -> AuthFlowCoordinator {
        return DefaultAuthFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
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
        return .init(viewModel: makeSigninViewModel(coordinator: coordinator))
    }
    
    private func makeSigninViewModel(
        coordinator: AuthFlowCoordinator
    ) -> SigninViewModel {
        return SigninViewModel(
            dependencies: (
                coordinator: coordinator,
                authUseCase: makeAuthUseCase(),
                workplaceUseCase: makeWorkplaceUseCase(),
                validationService: DefaultValidationService.shared,
                wireframe: DefaultWireframe()
            )
        )
    }
    
    func makeWorkplaceUseCase() -> WorkplaceUseCase {
        return DefaultWorkplaceUseCase(workplaceRepository: makeWorkplaceRepository())
    }
    
    private func makeWorkplaceRepository() -> WorkplaceRepository {
        return DefaultWorkplaceRepository(network: WorkplaceNetworking(), storage: SQLiteWorkplaceStorage())
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
    
    func makeAccountRecoveryOptionViewController(coordinator: any AuthFlowCoordinator) -> CredentialRecoveryOptionsViewController {
        return .init()
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
