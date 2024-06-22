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
        let uid: Driver<String>
        let password: Driver<String>
        let repeatedPassword: Driver<String>
        let duplicationCheck: Signal<()>
        let nextStep: Signal<()>
    }
    
    struct Output {
        let uidAvailable: Driver<Bool>
        let validatedPassword: Driver<Bool>
        let validatedRepeatedPassword: Driver<Bool>
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
    
    func transform(_ input: Input) -> Output {
        
        let validatedUID = input.uid
        
        let uidAvailable = input.duplicationCheck.withLatestFrom(validatedUID)
            .flatMapLatest { [weak self] authCode -> Driver<Bool> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.authUseCase.authCodeVerification(authCode)
                // .trackActivity(signingIn)
                    .asDriver(onErrorJustReturn: false)
            }
            .startWith(false)
        
        let validatedPassword = input.password
            .map { password in
                return self.validationService.validatePassword(password)
                    .isValid
            }

        let validatedPasswordRepeated = Driver.combineLatest(input.password, input.repeatedPassword, resultSelector: validationService.validateRepeatedPassword)
            .map {
                $0.isValid
            }
        
        return Output(
            uidAvailable: uidAvailable,
            validatedPassword: validatedPassword,
            validatedRepeatedPassword: validatedPasswordRepeated
        )
    }
}
