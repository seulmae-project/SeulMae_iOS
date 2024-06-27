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
        let validatedUserID: Driver<ValidationResult>
        let userIDVerificationEnabled: Driver<Bool>
        let verifiedUserID: Driver<Bool>
        let validatedPassword: Driver<ValidationResult>
        let validatedRepeatedPassword: Driver<ValidationResult>
        let nextStepEnabled: Driver<Bool>
    }
    
    // MARK: - Dependency
    
    private let coordinator: AuthFlowCoordinator
    
    private let authUseCase: AuthUseCase
    
    private let validationService: ValidationService
    
    private let wireframe: Wireframe
    
    private let request: SignupRequest
    
    // MARK: - Life Cycle
    
    init(
        dependency: (
            coordinator: AuthFlowCoordinator,
            authUseCase: AuthUseCase,
            validationService: ValidationService,
            wireframe: Wireframe,
            request: SignupRequest
        )
    ) {
        self.coordinator = dependency.coordinator
        self.authUseCase = dependency.authUseCase
        self.validationService = dependency.validationService
        self.wireframe = dependency.wireframe
        self.request = dependency.request
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
        
        // MARK: UserID Verification
        
        let validatedUserID = input.userID
            .flatMapLatest { [weak self] userID -> Driver<ValidationResult> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.validationService.validateUserID(userID)
                    .asDriver()
            }
        
        let userIDVerificationEnabled = Driver.combineLatest(
            validatedUserID, loading) { userID, loading in
                userID.isValid &&
                !loading
            }
            .distinctUntilChanged()
        
        let verifiedUserID = input.verifyUserID.withLatestFrom(input.userID)
            .flatMapLatest { [weak self] userID -> Driver<Bool> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.authUseCase
                    .userIDAvailable(userID)
                    .trackActivity(indicator)
//                    .map { available -> ValidationResult in
//                        return available ? .ok(message: "사용가능한 아이디입니다") :
//                            .failed(message: "사용중인 아이디입니다")
//                    }
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
            verifiedUserID, loading) { verified, loading in
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
            validatedUserID: validatedUserID,
            userIDVerificationEnabled: userIDVerificationEnabled,
            verifiedUserID: verifiedUserID,
            validatedPassword: validatedPassword,
            validatedRepeatedPassword: validatedPasswordRepeated,
            nextStepEnabled: nextStepEnabled
        )
    }
}
