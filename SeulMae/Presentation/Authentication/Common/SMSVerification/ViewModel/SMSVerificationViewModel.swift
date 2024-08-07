//
//  SMSVerificationViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 6/11/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SMSVerificationViewModel: ViewModel {
    
    struct Input {
        let phoneNumber: Driver<String>
        let code: Driver<String>
        let sendSMSCode: Signal<()>
        let verifyCode: Signal<()>
        let nextStep: Signal<()>
    }
    
    struct Output {
        let item: Driver<SMSVerificationItem>
        let isLoading: Driver<Bool>
        let validatedPhoneNumber: Driver<ValidationResult>
        let sendSMSCodeEnabled: Driver<Bool>
        let isSent: Driver<SMSRequestStatus>
        let verifySMSCodeEnabled: Driver<Bool>
        let verifiedCode: Driver<Bool>
        let nextStepEnabled: Driver<Bool>
    }
    
    // MARK: - Properties
    
    private var phoneNumber: String = ""
    private var sendCount: Int = 0
    
    // MARK: - Dependency
    
    private let coordinator: AuthFlowCoordinator
    private let authUseCase: AuthUseCase
    private let validationService: ValidationService
    private let wireframe: Wireframe
    private let item: SMSVerificationItem
    
    // MARK: - Life Cycle
    
    init(
        dependency: (
            coordinator: AuthFlowCoordinator,
            authUseCase: AuthUseCase,
            validationService: ValidationService,
            wireframe: Wireframe,
            item: SMSVerificationItem
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
        let isLoading = indicator.asDriver()
        
        // MARK: Send SMS Code
        
        let validatedPhoneNumber = input.phoneNumber
            .flatMapLatest { [weak self] phoneNumber -> Driver<ValidationResult> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.validationService
                    .validatePhoneNumber(phoneNumber)
                    .asDriver()
            }
        
        let sendSMSCodeEnabled = Driver.combineLatest(
            validatedPhoneNumber, isLoading) { phoneNumber, loading in
                phoneNumber.isValid && !loading
            }
            .distinctUntilChanged()
        
        let isSent = input.sendSMSCode.withLatestFrom(input.phoneNumber)
            .flatMapLatest { [weak self] phoneNumber -> Driver<SMSRequestStatus> in
                guard let strongSelf = self else { return .empty() }
                strongSelf.phoneNumber = phoneNumber
                if strongSelf.sendCount != 3 {
                    strongSelf.sendCount += 1
                    return strongSelf.authUseCase
                        .sendSMSCode(phoneNumber: phoneNumber, email: nil)
                        .trackActivity(indicator)
                        .map { _ in (strongSelf.sendCount == 1) ? .request : .reRequest }
                        .asDriver(onErrorDriveWith: .empty())
                    // TODO: API Error 핸들링 필요
                } else {
                    return strongSelf.wireframe
                        .promptFor(
                            "인증번호 재전송은 3번까지 가능합니다",
                            cancelAction: "확인",
                            actions: []
                        )
                        .map { _ in .pending }
                        .asDriver()
                }
            }
            .startWith(.pending)
        
        // MARK: Verify SMS Code
        
        let validatedCode = input.code.map { $0.count == 6 }
        let verifySMSCodeEnabled = Driver.combineLatest(
            isSent, validatedCode, isLoading) { isSent, code, loading in
                isSent.isSending && code && !loading
            }
            .distinctUntilChanged()
        
        let verifiedCode = input.verifyCode.withLatestFrom(input.code)
            .flatMapLatest { [weak self] code -> Driver<Bool> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.authUseCase
                    .verifySMSCode(phoneNumber: strongSelf.phoneNumber, code: code)
                    .trackActivity(indicator)
                    .asDriver(onErrorJustReturn: false)
            }
            .startWith(false)
        
        // MARK: Flow Logic
        
        let nextStepEnabled = Driver.combineLatest(
            verifiedCode, isLoading) { verified, loading in
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
            isLoading: isLoading,
            validatedPhoneNumber: validatedPhoneNumber,
            sendSMSCodeEnabled: sendSMSCodeEnabled,
            isSent: isSent,
            verifySMSCodeEnabled: verifySMSCodeEnabled,
            verifiedCode: verifiedCode,
            nextStepEnabled: nextStepEnabled
        )
    }
}