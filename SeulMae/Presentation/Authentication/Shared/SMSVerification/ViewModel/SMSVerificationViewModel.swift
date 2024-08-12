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
        let isCodeMatched: Driver<Bool>
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
                // TODO: - 인증이 성공했을 때 저장으로 변경
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
                // MARK: 로딩인 경우는 api 만 전달할 수 없게 끔 변경 (현재 버튼 비활성화까지 됌)
            }
            .distinctUntilChanged()
        
        let isCodeMatched = input.verifyCode.withLatestFrom(input.code)
            .flatMapLatest { [weak self] code -> Driver<Bool> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.authUseCase
                    .verifySMSCode(phoneNumber: strongSelf.phoneNumber, code: code)
                    .trackActivity(indicator)
                    .flatMapLatest { isMatched in
                        let message = isMatched ? "휴대폰 번호 인증이 완료 되었습니다" : "인증번호가 일치하지 않습니다"
                        return strongSelf.wireframe.promptFor(
                            message,
                            cancelAction: "확인",
                            actions: []
                        )
                        .map { _ in return isMatched }
                    }
                    .asDriver(onErrorJustReturn: false)
            }
            .startWith(false)
        
        // MARK: Flow Logic
        
        let nextStepEnabled = Driver.combineLatest(
            isCodeMatched, isLoading) { verified, loading in
                verified &&
                !loading
            }
            .distinctUntilChanged()
        
        Task {
            for await _ in input.nextStep.values {
                switch item {
                case .signup:
                    var request = SignupRequest()
                    request.updatePhoneNumber(phoneNumber)
                    coordinator.showAccountSetup(item: .signup, request: request)
                case .idRecovery:
                    break
                    // coordinator.showAccountSetup(request: SignupRequest())
                case .passwordRecovery:
                    break
                    // coordinator.showAccountSetup(request: SignupRequest())
                }
            }
        }
        
        return Output(
            item: .just(item),
            isLoading: isLoading,
            validatedPhoneNumber: validatedPhoneNumber,
            sendSMSCodeEnabled: sendSMSCodeEnabled,
            isSent: isSent,
            verifySMSCodeEnabled: verifySMSCodeEnabled,
            isCodeMatched: isCodeMatched,
            nextStepEnabled: nextStepEnabled
        )
    }
}
