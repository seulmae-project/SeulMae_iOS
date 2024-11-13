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
        let username: Driver<String>
        let phoneNumber: Driver<String>
        let sendSMSCode: Signal<()>
        let timeout: Driver<Bool>
        let smsCode: Driver<String>
        let verifyCode: Signal<()>
        let pass: Signal<()>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let type: Driver<SMSVerificationType>
        let validatedPhoneNumber: Driver<ValidationResult>
        let sendSMSCodeEnabled: Driver<Bool>
        let isSMSCodeSent: Driver<SMSRequestStatus>
        let verifySMSCodeEnabled: Driver<Bool>
    }
    
    // MARK: - Dependencies

    private let coordinator: AuthFlowCoordinator
    private let authUseCase: AuthUseCase
    private let validationService: ValidationService
    private let wireframe: Wireframe
    private let type: SMSVerificationType

    // MARK: - Life Cycle Methods

    init(
        dependencies: (
            coordinator: AuthFlowCoordinator,
            authUseCase: AuthUseCase,
            validationService: ValidationService,
            wireframe: Wireframe,
            type: SMSVerificationType
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.authUseCase = dependencies.authUseCase
        self.validationService = dependencies.validationService
        self.wireframe = dependencies.wireframe
        self.type = dependencies.type
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let tracker = ActivityIndicator()
        let loading = tracker.asDriver()

        // MARK: Send SMS Code
        
        let validatedPhoneNumber = input.phoneNumber
            .asObservable()
            .flatMapLatest(validationService.validatePhoneNumber(_:))
            .asDriver()

        let sendSMSCodeEnabled = Driver.combineLatest(
            validatedPhoneNumber, loading) { phoneNumber, loading in
                phoneNumber.isValid &&
                !loading
            }
            .distinctUntilChanged()

        let userInfo = Driver.combineLatest(input.phoneNumber, input.username) { (phoneNumber: $0, name: $1) }

        let isCodeSent = input.sendSMSCode
            .withLatestFrom(userInfo)
            .withUnretained(self)
            .flatMapLatest { (self, pair) -> Driver<SMSRequestStatus> in
                return self.authUseCase
                    .sendSMSCode(type: self.type, name: pair.name, phoneNumber: pair.phoneNumber)
                    .trackActivity(tracker)
                    .flatMap { isSent in
                        let message = isSent.isSending ? "인증번호가 전송되었습니다" : "인증번호 재전송은 3번까지 가능합니다"
                        return self.wireframe
                            .promptFor(message, cancelAction: "확인", actions: [])
                            .map { _ in isSent }
                    }
                    .asDriver()
            }
        let passSend = input.pass.map { _ in SMSRequestStatus.request }.asDriver()
        let isSent = Driver.merge(isCodeSent, passSend)

        // MARK: Verify SMS Code
        
        let validatedCode = input.smsCode.map { $0.count == 6 }
        let verifySMSCodeEnabled = Driver.combineLatest(
            isSent, validatedCode, loading, input.timeout) { isSent, code, loading, timeout in
                isSent.isSending && code && !loading && !timeout
            }
            .distinctUntilChanged()

        let codeAndPhoneNumber = Driver.combineLatest(
            input.smsCode, input.phoneNumber) { (code: $0, phoneNumber: $1) }

        let smsVerificationResult = input.verifyCode
            .withLatestFrom(codeAndPhoneNumber)
            .withUnretained(self)
            .flatMapLatest { (self, pair) -> Driver<SMSVerificationResult> in
                return self.authUseCase
                    .verifySMSCode(phoneNumber: pair.phoneNumber, code: pair.code)
                    .trackActivity(tracker)
                    .flatMapLatest { result in
                        let message = result.isSuccess ? "본인 인증이 완료 되었습니다" : "인증번호가 일치하지 않습니다"
                        return self.wireframe.promptFor(message, cancelAction: "확인", actions: [])
                        .map { _ in return result }
                    }
                    .asDriver()
            }

        let passResult = input.pass.withLatestFrom(passSend)
            .map { _ in return SMSVerificationResult(accountId: "yonggipo", isSuccess: true) }
            .asDriver()

        let resultAndPhoneNumber =
        Driver.combineLatest(Driver.merge(smsVerificationResult, passResult), input.phoneNumber) { (result: $0, phoneNumber: $1) }

        // MARK: - Flow Logic

        Task {
            for await (result, phoneNumber) in resultAndPhoneNumber.values {
                if !result.isSuccess { return }
                switch type {
                case .signUp: // 폰번호 아이디
                    var userInfo = UserInfo()
                    userInfo.phoneNumber = phoneNumber
                    coordinator.showAccountSetup(userinfo: userInfo)
                case .idRecovery:
                    coordinator.showIdRecovery(result: result)
                case .pwRecovery:
                    coordinator.showPwRecovery(result: result)
                }
            }
        }
        
        return Output(
            loading: loading,
            type: .just(type),
            validatedPhoneNumber: validatedPhoneNumber,
            sendSMSCodeEnabled: sendSMSCodeEnabled,
            isSMSCodeSent: isSent,
            verifySMSCodeEnabled: verifySMSCodeEnabled
        )
    }
}
