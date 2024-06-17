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
        let accountRecovery: Signal<()>
        let signup: Signal<()>
    }
    
    struct Output {
        
    }
    
    // MARK: - Dependency
    
    private let authCoordinator: AuthFlowCoordinator
    
    private let authUseCase: AuthUseCase
    
    private let validationService: ValidationService
    
    // MARK: - Life Cycle
    
    init(
        dependency: (
            authCoordinator: AuthFlowCoordinator,
            authUseCase: AuthUseCase,
            validationService: ValidationService
        )
    ) {
        self.authCoordinator = dependency.authCoordinator
        self.authUseCase = dependency.authUseCase
        self.validationService = dependency.validationService
    }
        
    func transform(_ input: Input) -> Output {
        
        // MARK: - Signin
        
        let emailAndPassword = Driver.combineLatest(input.email, input.password) { (email: $0, password: $1) }
        let signedIn = input.signup.withLatestFrom(emailAndPassword)
            .flatMapLatest { [weak self] pair -> Driver<Bool> in
                guard let weakSelf = self else { return .empty() }
                return weakSelf.authUseCase.signin(pair.email, pair.password)
                    // .trackActivity(signingIn)
                    .asDriver(onErrorJustReturn: false)
            }
//            .flatMapLatest { loggedIn -> Driver<Bool> in
//                let message = loggedIn ? "Mock: Signed in to GitHub." : "Mock: Sign in to GitHub failed"
//                return wireframe.promptFor(message, cancelAction: "OK", actions: [])
//                    // propagate original value
//                    .map { _ in
//                        loggedIn
//                    }
//                    .asDriver(onErrorJustReturn: false)
//            }
        
        // MARK: - Kakao Signin
        
        let _ = input.kakaoSignin
        
        // MARK: - Flow
        
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
        
//        Task {
//            for await _ in await accountRecovery.values {
//                Swift.print("-- flow: showEmailRecovery")
//                ? authCoordinator.showEmailRecovery() : authCoordinator.showEmailRecovery()
//            }
//        }
    
        Task {
            for await _ in await input.signup.values {
                Swift.print("-- flow: showPhoneVerification")
                authCoordinator.showPhoneVerification()
            }
        }
                                                        
        return Output()
    }
}
