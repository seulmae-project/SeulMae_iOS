//
//  PwRecoveryViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 11/2/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PwRecoveryViewModel: ViewModel {

    struct Input {
        let password: Driver<String>
        let repeatedPassword: Driver<String>
        let onReset: Signal<()>
    }

    struct Output {
        let laoding: Driver<Bool>
        let validatedPassword: Driver<ValidationResult>
        let validatedPasswordRepeated: Driver<ValidationResult>
        let resetEnabled: Driver<Bool>
    }

    private var disposeBag = DisposeBag()

    // MARK: - Dependencies

    private let coordinator: AuthFlowCoordinator
    private let authUseCase: AuthUseCase
    private let validationService: ValidationService
    private let wireframe: Wireframe
    private let result: SMSVerificationResult


    // MARK: - Life Cycle Methods

    init(
        dependencies: (
            coordinator: AuthFlowCoordinator,
            authUseCase: AuthUseCase,
            wireframe: Wireframe,
            validationService: ValidationService,
            result: SMSVerificationResult
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.authUseCase = dependencies.authUseCase
        self.wireframe = dependencies.wireframe
        self.validationService = dependencies.validationService
        self.result = dependencies.result
    }

    @MainActor func transform(_ input: Input) -> Output {
        let tracker = ActivityIndicator()
        let loading = tracker.asDriver()

        let validatedPw = input.password
            .map(validationService.validatePassword)

        let validatedPwRepeated = input.repeatedPassword.withLatestFrom(input.password, resultSelector: validationService.validateRepeatedPassword)

        let resetEnabled = Driver.combineLatest(
            loading, validatedPw, validatedPwRepeated) { loading, pw, pwRepeated in
                !loading &&
                pw.isValid &&
                pwRepeated.isValid
            }
            .distinctUntilChanged()
            .startWith(false)

        let recoveryResult = input.onReset.withLatestFrom(input.password)
            .withUnretained(self)
            .flatMapLatest { (self, password) in
                return self.authUseCase
                    .recoveryPassword(accountId: self.result.accountId, newPassword: password)
                    .trackActivity(tracker)
                    .asDriver()
            }

        recoveryResult
            .drive(with: self, onNext: { (self, result) in
                if !result.isRecovery { return }
                self.coordinator.showCompletion(tpye: .passwordRecovery)
            })
            .disposed(by: disposeBag)

        return .init(
            laoding: loading,
            validatedPassword: validatedPw,
            validatedPasswordRepeated: validatedPwRepeated,
            resetEnabled: resetEnabled
        )
    }
}
