//
//  SMSValidationViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 6/11/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SMSValidationViewModel: ViewModel {
    
    struct Input {
        let phoneNumber: Driver<String>
        let code: Driver<String>
        let validateSMS: Signal<()>
        let verifyCode: Signal<()>
        let nextStep: Signal<()>
    }
    
    struct Output {
        let item: Driver<SMSValidationItem>
        let validatedPhoneNumber: Driver<ValidationResult>
        let smsValidationEnabled: Driver<Bool>
        let validatedSMS: Driver<Bool>
        let codeVerificationEnabled: Driver<Bool>
        let verifiedCode: Driver<Bool>
        let nextStepEnabled: Driver<Bool>
    }
    
    // MARK: - Dependency
    
    private let coordinator: AuthFlowCoordinator
    
    private let authUseCase: AuthUseCase
    
    private let validationService: ValidationService

    private let wireframe: Wireframe
    
    private let item: SMSValidationItem
    
    // MARK: - Life Cycle
    
    init(
        dependency: (
            coordinator: AuthFlowCoordinator,
            authUseCase: AuthUseCase,
            validationService: ValidationService,
            wireframe: Wireframe,
            item: SMSValidationItem
        )
    ) {
        self.coordinator = dependency.coordinator
        self.authUseCase = dependency.authUseCase
        self.validationService = dependency.validationService
        self.wireframe = dependency.wireframe
        self.item = dependency.item
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
        
        // MARK: SMS Validation
        
        let validatedPhoneNumber = input.phoneNumber
            .flatMapLatest { [weak self] phoneNumber -> Driver<ValidationResult> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.validationService.validatePhoneNumber(phoneNumber)
                    .asDriver()
            }
        
        let smsValidationEnabled = Driver.combineLatest(
            validatedPhoneNumber, loading) { phoneNumber, loading in
                phoneNumber.isValid &&
                !loading
            }
            .distinctUntilChanged()
        
        let validatedSMS = input.validateSMS.withLatestFrom(input.phoneNumber)
            .flatMapLatest { [weak self] phoneNumber -> Driver<Bool> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.authUseCase.smsVerification(phoneNumber, nil)
                    .trackActivity(indicator)
                    .asDriver(onErrorJustReturn: false)
                // TODO: 틀린 경우 얼럿
            }
            .startWith(false)
        
        // MARK: Code Verification
        
        let validatedCode = input.code
            .map { $0.count == 6 }
        let codeVerificationEnabled = Driver.combineLatest(
            validatedCode, loading) { code, loading in
                code &&
                !loading
            }
            .distinctUntilChanged()
        
        let verifiedCode = input.verifyCode.withLatestFrom(input.code)
            .flatMapLatest { [weak self] code -> Driver<Bool> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.authUseCase
                    .codeVerification(code)
                    .trackActivity(indicator)
                    .asDriver(onErrorJustReturn: false)
            }
            .startWith(false)
        
        // MARK: Flow Logic
        
        let nextStepEnabled = Driver.combineLatest(
            validatedSMS, verifiedCode, loading) { validated, verified, loading in
                validated &&
                verified &&
                !loading
            }
            .distinctUntilChanged()
        
        Task {
            for await _ in input.nextStep.values {
                coordinator.showAccountSetup(request: SignupRequest())
            }
        }
        
        return Output(
            item: .just(item),
            validatedPhoneNumber: validatedPhoneNumber,
            smsValidationEnabled: smsValidationEnabled,
            validatedSMS: validatedSMS,
            codeVerificationEnabled: codeVerificationEnabled,
            verifiedCode: verifiedCode,
            nextStepEnabled: nextStepEnabled
        )
    }
}
