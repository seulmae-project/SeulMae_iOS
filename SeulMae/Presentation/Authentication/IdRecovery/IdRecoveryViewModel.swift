//
//  IdRecoveryViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 11/2/24.
//

import Foundation
import RxSwift
import RxCocoa

final class IdRecoveryViewModel: ViewModel {

    struct Input {
        let passwordRecovery: Signal<()>
        let signIn: Signal<()>
    }

    struct Output {
        let accountId: Driver<String>
    }

    // MARK: - Dependencies

    private let coordinator: AuthFlowCoordinator
    private let result: SMSVerificationResult

    // MARK: - Life Cycle Methods

    init(
        dependencies: (
            coordinator: AuthFlowCoordinator,
            result: SMSVerificationResult
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.result = dependencies.result
    }

    @MainActor func transform(_ input: Input) -> Output {
        
        Task {
            for await _ in input.passwordRecovery.values {
                coordinator.showSMSValidation(type: .pwRecovery)
            }
        }

        Task {
            for await _ in input.signIn.values {
                coordinator.showSignin()
            }
        }


        return .init(
            accountId: .just(result.accountId)
        )
    }
}
