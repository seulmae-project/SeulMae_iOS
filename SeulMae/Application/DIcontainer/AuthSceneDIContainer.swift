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
        let userNetworking: UserNetworking
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Private Methods

    private func makeAuthUseCase() -> AuthUseCase {
        return DefaultAuthUseCase(
            dependencies: (
                authRepository: makeAuthRepository(),
                userRepository: makeUserRepository(),
                workplaceRepository: makeWorkplaceRepository()
            )
        )
    }

    private func makeWorkplaceUseCase() -> WorkplaceUseCase {
        return DefaultWorkplaceUseCase(workplaceRepository: makeWorkplaceRepository())
    }

    private func makeAuthRepository() -> AuthRepository {
        return DefaultAuthRepository(network: dependencies.authNetworking)
    }

    private func makeUserRepository() -> UserRepository {
        return UserRepository(network: dependencies.userNetworking)
    }

    private func makeWorkplaceRepository() -> WorkplaceRepository {
        return DefaultWorkplaceRepository(
            network: WorkplaceNetworking(),
            storage: SQLiteWorkplaceStorage()
        )
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

    // MARK: - Signin VC && VM

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

    // MARK: - SMS Validation VC && VM

    func makeSMSValidationVC(
        coordinator: any AuthFlowCoordinator,
        type: SMSVerificationType
    ) -> SMSVerificationViewController {
        return .init(
            viewModel: makeSMSValidationViewModel(
                coordinator: coordinator, item: type
            )
        )
    }

    private func makeSMSValidationViewModel(
        coordinator: AuthFlowCoordinator,
        item: SMSVerificationType
    ) -> SMSVerificationViewModel {
        return SMSVerificationViewModel(
            dependencies: (
                coordinator: coordinator,
                authUseCase: makeAuthUseCase(),
                validationService: DefaultValidationService.shared,
                wireframe: DefaultWireframe(),
                type: item
            )
        )
    }

    // MARK: - Id Recovery VC && VM

    func makeIdRecoveryVC(coordinator: any AuthFlowCoordinator, result: SMSVerificationResult) -> IdRecoveryViewController {
        .init(
            viewModel: makeIdRecoveryVM(
                coordinator: coordinator,
                result: result
            ))
    }

    private func makeIdRecoveryVM(coordinator: AuthFlowCoordinator, result: SMSVerificationResult) -> IdRecoveryViewModel {
        .init(
            dependencies: (
                coordinator: coordinator,
                result: result
            ))
    }

    // MARK: - Pw Recovery VC && VM

    func makePwRecoveryVC(coordinator: any AuthFlowCoordinator, result: SMSVerificationResult) -> PwRecoveryViewController {
        .init(
            viewModel: makePwRecoveryVM(
                coordinator: coordinator,
                result: result
            ))
    }

    private func makePwRecoveryVM(coordinator: AuthFlowCoordinator, result: SMSVerificationResult) -> PwRecoveryViewModel {
        .init(
            dependencies: (
                coordinator: coordinator,
                authUseCase: makeAuthUseCase(),
                wireframe: DefaultWireframe(),
                validationService: DefaultValidationService.shared,
                result: result
            ))
    }

    // MARK: - Completion VC && VM

    func makeCompletionVC(
        coordinator: any AuthFlowCoordinator,
        type: CompletionType
    ) -> CompletionViewController {
        return .init(
            viewModel: makeCompletionViewModel(
                coordinator: coordinator,
                type: type
            ))
    }
    
    private func makeCompletionViewModel(
        coordinator: AuthFlowCoordinator,
        type: CompletionType
    ) -> CompletionViewModel {
        return CompletionViewModel(
            dependencies: (
                coordinator: coordinator,
                type: type
            )
        )
    }

    // MARK: - Account Setup VC && VM

    func makeAccountSetupVC(coordinator: any AuthFlowCoordinator, userInfo: UserInfo) -> AccountSetupViewController {
        return .create(
            viewModel: makeAccountSetupViewModel(
                coordinator: coordinator,
                userInfo: userInfo
            )
        )
    }
    
    private func makeAccountSetupViewModel(coordinator: AuthFlowCoordinator, userInfo: UserInfo) -> AccountSetupViewModel {
        return AccountSetupViewModel(
            dependencies: (
                coordinator: coordinator,
                authUseCase: makeAuthUseCase(),
                validationService: DefaultValidationService.shared,
                wireframe: DefaultWireframe(),
                userInfo: userInfo
            )
        )
    }
    
    func makeProfileSetupViewController(
        coordinator: any AuthFlowCoordinator,
        request: UserInfo,
        signupType: SignupType
    ) -> ProfileSetupViewController {
        return .init(
            viewModel: makeProfileSetupViewModel(
                coordinator: coordinator,
                request: request,
                signupType: signupType
            )
        )
    }
    
    private func makeProfileSetupViewModel(
        coordinator: AuthFlowCoordinator,
        request: UserInfo,
        signupType: SignupType
    ) -> ProfileSetupViewModel {
        return ProfileSetupViewModel(
            dependencies: (
                coordinator: coordinator,
                authUseCase: makeAuthUseCase(),
                validationService: DefaultValidationService.shared,
                wireframe: DefaultWireframe(),
                request: request,
                signupType: signupType
            )
        )
    }
    
    func makeAccountRecoveryOptionViewController(
        coordinator: any AuthFlowCoordinator
    ) -> CredentialRecoveryOptionsViewController {
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
