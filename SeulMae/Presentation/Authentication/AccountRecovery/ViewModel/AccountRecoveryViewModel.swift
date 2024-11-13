//
//  IDRecoveryViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 6/12/24.
//

import RxSwift
import RxCocoa

final class AccountRecoveryViewModel: ViewModel {
    struct Input {
        let movePasswordRecovery: Signal<()>
        let moveSignin: Signal<()>
    }
    
    struct Output {
        let item: Driver<AccountRecoveryItem>
    }
    
    // MARK: - Dependency
    
    private let coordinator: AuthFlowCoordinator
    private let authUseCase: AuthUseCase
    private let wireframe: Wireframe
    private let item: AccountRecoveryItem
    
    // MARK: - Life Cycle
    
    init(
        dependency: (
            coordinator: AuthFlowCoordinator,
            authUseCase: AuthUseCase,
            wireframe: Wireframe,
            item: AccountRecoveryItem
        )
    ) {
        self.coordinator = dependency.coordinator
        self.authUseCase = dependency.authUseCase
        self.wireframe = dependency.wireframe
        self.item = dependency.item
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        // Move to password recovery view
        Task {
            for await _ in input.movePasswordRecovery.values {
                // coordinator.show
            }
        }
        // Move to sign in view
        Task {
            for await _ in input.moveSignin.values {
                coordinator.showSignin()
            }
        }
        return Output(item: .just(item))
    }
}
