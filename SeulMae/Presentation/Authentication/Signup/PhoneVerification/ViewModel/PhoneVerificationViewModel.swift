//
//  PhoneVerificationViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 6/11/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PhoneVerificationViewModel: ViewModel {
    
    struct Input {
        let phoneNumber: Driver<String>
        let authCode: Driver<String>
        let sendAuth: Signal<()>
        let verifyCode: Signal<()>
        let nextStep: Signal<()>
    }
    
    struct Output {
        let requested: Driver<Bool>
        let verified: Driver<Bool>
    }
    
    // MARK: - Dependency
    
    private let coordinator: AuthFlowCoordinator
    
    private let authUseCase: AuthUseCase
    
    private let validationService: ValidationService
    
    private let wireframe: Wireframe
    
    // MARK: - Life Cycle
    
    init(
        dependency: (
            coordinator: AuthFlowCoordinator,
            authUseCase: AuthUseCase,
            validationService: ValidationService,
            wireframe: Wireframe
        )
    ) {
        self.coordinator = dependency.coordinator
        self.authUseCase = dependency.authUseCase
        self.validationService = dependency.validationService
        self.wireframe = dependency.wireframe
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let validatedPhoneNumber = input.phoneNumber
        
        Task {
            for await phoneNumber in validatedPhoneNumber.values {
                Swift.print("-- phoneNumber: \(phoneNumber)")
            }
        }
        
        Task {
            for await password in input.sendAuth.values {
                Swift.print("-- sendAuth: sendAuth button tapped")
            }
        }
        
        let requested = input.sendAuth.withLatestFrom(validatedPhoneNumber)
            .flatMapLatest { [weak self] phoneNumber -> Driver<Bool> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.authUseCase.smsVerification(phoneNumber, nil)
                // .trackActivity(signingIn)
                    .asDriver(onErrorJustReturn: false)
            }
        
        let validatedCode = input.authCode
        
        let verified = input.verifyCode.withLatestFrom(validatedCode)
            .flatMapLatest { [weak self] authCode -> Driver<Bool> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.authUseCase.authCodeVerification(authCode)
                // .trackActivity(signingIn)
                    .asDriver(onErrorJustReturn: false)
            }
            .startWith(false)
        
        
        Task {
            for await _ in input.nextStep.values {
                coordinator.showAccountSetup()
            }
        }
        
        return Output(
            requested: requested,
            verified: verified
        )
    }
}
