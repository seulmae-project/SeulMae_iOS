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
        let accountID: Driver<String>
        let verifyAccountID: Signal<()>
        let password: Driver<String>
        let repeatedPassword: Driver<String>
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
    private var request: SignupRequest
    
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
        
        let validatedAccountID = input.accountID
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
        
        let isAvailable = input.verifyAccountID.withLatestFrom(input.accountID)
            .flatMapLatest { [weak self] userID -> Driver<Bool> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.authUseCase
                    .verifyAccountID(userID)
                    .trackActivity(indicator)
                    .flatMap { isDuplicated in
                        let available = !isDuplicated
                        let message = available ? "사용가능한 아이디입니다" : "사용중인 아이디입니다"
                        return strongSelf.wireframe
                            .promptFor(message, cancelAction: "확인", actions: [])
                            .map { _ in return available }
                    }
                    .asDriver(onErrorJustReturn: false)
            }
            .startWith(false)
        
        // MARK: Password Validation
        
        let validatedPassword = input.password
            .map { [weak self] password -> ValidationResult in
                guard let strongSelf = self else { return .failed(message: "") }
                return strongSelf.validationService
                    .validatePassword(password)
            }
            .startWith(.default(message: ""))

        let validatedPasswordRepeated = Driver.combineLatest(input.password, input.repeatedPassword, resultSelector: validationService.validateRepeatedPassword)
            .startWith(.default(message: ""))
        
        // MARK: Flow Logic
        
        let nextStepEnabled = Driver.combineLatest(
            loading, validatedAccountID, isAvailable, validatedPassword, validatedPasswordRepeated) { loading, accountID, verified, password, repeatedPassword in
                !loading &&
                accountID.isValid &&
                verified &&
                password.isValid &&
                repeatedPassword.isValid
            }
            .distinctUntilChanged()
        
        let credentials = Driver.combineLatest(input.accountID, input.password) { (account: $0, password: $1) }

        let nextStep = input.nextStep.withLatestFrom(credentials)
    
        Task {
            for await nextStep in nextStep.values {
                request.accountId = nextStep.account
                request.password = nextStep.password
                coordinator.showProfileSetup(request: request, signupType: .default)
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
