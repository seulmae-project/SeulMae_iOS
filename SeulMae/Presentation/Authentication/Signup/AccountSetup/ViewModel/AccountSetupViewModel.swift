//
//  AccountSetupViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 6/11/24.
//

import Foundation
import RxSwift
import RxCocoa

final class AccountSetupViewModel: ViewModel {
    
    struct Input {
        let userID: Driver<String>
        let password: Driver<String>
        let repeatedPassword: Driver<String>
        let verifyUserID: Signal<()>
        let nextStep: Signal<()>
    }
    
    struct Output {
        let item: Driver<AccountSetupItem>
        let validatedAccountID: Driver<ValidationResult>
        let validateAccountIDEnabled: Driver<Bool>
        let isAvailable: Driver<Bool>
        let validatedPassword: Driver<ValidationResult>
        let validatedRepeatedPassword: Driver<ValidationResult>
        let nextStepEnabled: Driver<Bool>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: AuthFlowCoordinator
    private let authUseCase: AuthUseCase
    private let validationService: ValidationService
    private let wireframe: Wireframe
    private let item: AccountSetupItem
    private let request: SignupRequest
    
    // MARK: - Life Cycle
    
    init(
        dependencies: (
            coordinator: AuthFlowCoordinator,
            authUseCase: AuthUseCase,
            validationService: ValidationService,
            wireframe: Wireframe,
            item: AccountSetupItem,
            request: SignupRequest
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.authUseCase = dependencies.authUseCase
        self.validationService = dependencies.validationService
        self.wireframe = dependencies.wireframe
        self.item = dependencies.item
        self.request = dependencies.request
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
        
        // MARK: Account ID Validation
        
        let validatedAccountID = input.userID
            .flatMapLatest { [weak self] accountID -> Driver<ValidationResult> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.validationService
                    .validateUserID(accountID)
                    .asDriver()
            }
        
        let validateAccountIDEnabled = Driver.combineLatest(
            validatedAccountID, loading) { accountID, loading in
                accountID.isValid &&
                !loading
            }
            .distinctUntilChanged()
        
        let isAvailable = input.verifyUserID.withLatestFrom(input.userID)
            .flatMapLatest { [weak self] userID -> Driver<Bool> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.authUseCase
                    .verifyAccountID(userID)
                    .trackActivity(indicator)
                    .flatMap { available in
                        let message = available ? "사용가능한 아이디입니다" : "사용중인 아이디입니다"
                        return strongSelf.wireframe.promptFor(message, cancelAction: "확인", actions: [])
                            .map { _ in return available }
                    }
                    .asDriver(onErrorJustReturn: false)
            }
            .startWith(false)
        
        // MARK: Password Validation
        
        let validatedPassword = input.password
            .map { password in
                return self.validationService.validatePassword(password)
            }

        let validatedPasswordRepeated = Driver.combineLatest(input.password, input.repeatedPassword, resultSelector: validationService.validateRepeatedPassword)
        
        // MARK: Flow Logic
        
        let nextStepEnabled = Driver.combineLatest(
            isAvailable, loading) { verified, loading in
                verified &&
                !loading
            }
            .distinctUntilChanged()
        
        Task {
            for await _ in input.nextStep.values {
                coordinator.showProfileSetup(request: request)
            }
        }
        
        return Output(
            item: .just(item),
            validatedAccountID: validatedAccountID,
            validateAccountIDEnabled: validateAccountIDEnabled,
            isAvailable: isAvailable,
            validatedPassword: validatedPassword,
            validatedRepeatedPassword: validatedPasswordRepeated,
            nextStepEnabled: nextStepEnabled
        )
    }
}
