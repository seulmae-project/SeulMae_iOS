//
//  SigninViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 6/12/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SigninViewModel: ViewModel {
    
    struct Input {
        let email: Driver<String>
        let password: Driver<String>
        let signin: Signal<()>
        let kakaoSignin: Signal<()>
        let validateSMS: Signal<SMSValidationItem>
    }
    
    struct Output {
        let signedIn: Driver<Bool>
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
        
        // MARK: - Signin
        
        let emailAndPassword = Driver.combineLatest(input.email, input.password) { (email: $0, password: $1) }
        
        Task {
            for await eamil in input.email.values {
                Swift.print("-- email: \(eamil)")
            }
        }
        
        Task {
            for await password in input.password.values {
                Swift.print("-- password: \(password)")
            }
        }
        
        Task {
            for await password in input.signin.values {
                Swift.print("-- signin: signin button tapped")
            }
        }
        
        let signedIn = input.signin.withLatestFrom(emailAndPassword)
            .flatMapLatest { [weak self] pair -> Driver<Bool> in
                guard let weakSelf = self else { return .empty() }
                return weakSelf.authUseCase
                    .signin(pair.email, pair.password)
                    .map { token in
                        Swift.print(token.accessToken)
                        Swift.print(token.refreshToken)
                        Swift.print(token.tokenType)
                        return true
                    }
                // .trackActivity(signingIn)
                    .asDriver { error in
                        let message: String
                        if case .faildedToSignin(let reason) = error as? APIError {
                            message = reason
                        } else {
                            message = "??"
                        }
                        
                        return (self?.wireframe.promptFor(message, cancelAction: "OK", actions: [])
                            .map { _ in
                                return false
                            }
                            .asDriver(onErrorJustReturn: false))!
                    }
            }
        
        
        
        // MARK: - Kakao Signin

        let _ = input.kakaoSignin

//        let accountRecovery = input.accountRecovery
//            .flatMapLatest { _ -> Driver<Bool> in
//                let email = "Mock: Signed in to GitHub."
//                let password = "Mock: Sign in to GitHub failed"
//                return wireframe.promptFor(message, cancelAction: "OK", actions: [])
//                    .map { _ in
//                        loggedIn
//                    }
//                    .asDriver(onErrorJustReturn: false)
//            })
        
  
        // MARK: - Flow Logic
        
        Task {
            for await _ in signedIn.values {
                self.coordinator.startMain()
            }
        }
            
        Task {
            for await item in input.validateSMS.values {
                coordinator.showSMSValidation(item: item)
            }
        }
        
        return Output(signedIn: signedIn)
    }
}
