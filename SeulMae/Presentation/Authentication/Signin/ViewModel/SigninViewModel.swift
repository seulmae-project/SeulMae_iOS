//
//  SigninViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 6/12/24.
//

import RxSwift
import RxCocoa

final class SigninViewModel: ViewModel {
    
    struct Input {
        let email: Driver<String>
        let password: Driver<String>
        let signin: Signal<()>
        let kakaoSignin: Signal<()>
        let signup: Signal<()>
        let acountRecovery: Signal<()>
    }
    
    struct Output {
        
    }
    
    // MARK: - Dependency
    
    private let validationService: ValidationService
    
    private let authUseCase: AuthUseCase
    
    // MARK: - Life Cycle
    
    init(
        dependency: (
            validationService: ValidationService,
            authUseCase: AuthUseCase
        )
    ) {
        self.validationService = dependency.validationService
        self.authUseCase = dependency.authUseCase
    }
        
    func transform(_ input: Input) -> Output {
        
        let emailAndPassword = Driver.combineLatest(input.email, input.password) { (email: $0, password: $1) }
        let signedIn = input.signup.withLatestFrom(emailAndPassword)
//            .flatMapLatest { pair in
//                return API.signup(pair.email, password: pair.password)
//                    // .trackActivity(signingIn)
//                    .asDriver(onErrorJustReturn: false)
//            }
//            .flatMapLatest { loggedIn -> Driver<Bool> in
//                let message = loggedIn ? "Mock: Signed in to GitHub." : "Mock: Sign in to GitHub failed"
//                return wireframe.promptFor(message, cancelAction: "OK", actions: [])
//                    // propagate original value
//                    .map { _ in
//                        loggedIn
//                    }
//                    .asDriver(onErrorJustReturn: false)
//            }
                                                        
        return Output()
    }
    
}
