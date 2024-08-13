//
//  SigninViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 6/12/24.
//

import UIKit
import RxSwift
import RxCocoa
import KakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser

final class SigninViewModel: ViewModel {
    
    struct Input {
        let account: Driver<String>
        let password: Driver<String>
        let signin: Signal<()>
        let kakaoSignin: Signal<()>
        let validateSMS: Signal<SMSVerificationItem>
        let signup: Signal<()>
        let credentialOption: Signal<CredentialRecoveryOption>
    }
    
    struct Output {
        // let signedIn: Driver<Bool>
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
        
        let accountAndPassword = Driver.combineLatest(input.account, input.password) { (account: $0, password: $1) }

        
        let signedIn = input.signin.withLatestFrom(accountAndPassword)
            .flatMapLatest { [weak self] pair -> Driver<(AuthData?, Bool)> in
                guard let weakSelf = self else { return .empty() }
                return weakSelf.authUseCase
                    .signin(email: pair.account, password: pair.password, fcmToken: "")
                // .trackActivity(signingIn)
                    .map { authData in
                        Swift.print("authData: \(authData)")
                        return (authData, true)
                    }
                    .asDriver { error in
                        let message: String
                        if case .faildedToSignin(let reason) = error as? APIError {
                            message = reason
                        } else {
                            message = "??"
                        }
                        
                        return (self?.wireframe.promptFor(message, cancelAction: "OK", actions: [])
                            .map { _ in
                                return (nil, false)
                            }
                            .asDriver(onErrorJustReturn: (nil, false)))!
                    }
            }
        
        
        
        
        
        // MARK: - Kakao Signin
        
        let oAuthToken = input.kakaoSignin
            .flatMapLatest { _ -> Driver<OAuthToken> in
                if (UserApi.isKakaoTalkLoginAvailable()) {
                    Swift.print("☘️ login With Kakao Talk")
                    return UserApi.shared
                        .rx
                        .loginWithKakaoTalk()
                        .asDriver()
                } else {
                    Swift.print("☘️ login With Kakao Account")
                    return UserApi.shared
                        .rx
                        .loginWithKakaoAccount()
                        .asDriver()
                }
            }
        
//        let isSignedUp = oAuthToken.flatMapLatest { token in
//            
//        }
        
        
        Task {
            for await token in oAuthToken.values {
                Swift.print("☘️ Login With Kakao Success: \(token)")
                
            }
        }
  
        // MARK: - Flow Logic
        
        Task {
            for await (auth, signedIn) in signedIn.values {
                if signedIn {
                    Swift.print("로그인 성공")
                    // TODO: - authentication null 일 경우 핸들링 필요
                    if auth?.workplace.isEmpty ?? true {
                        coordinator.showSearchWorkplace()
                    } else {
                        coordinator.startMain()
                    }
                } else {
                    Swift.print("🥶🥶🥶 로그인 실패 🥶🥶🥶")
                }
            }
        }
            
        Task {
            for await item in input.validateSMS.values {
                coordinator.showSMSValidation(item: item)
            }
        }
        
        Task {
            for await _ in input.signup.values {
                coordinator.showSMSValidation(item: .signup)
            }
        }
        
        Task {
            for await credentialOption in input.credentialOption.values {
                if (credentialOption == .account) {
                    coordinator.showSMSValidation(item: .accountRecovery)
                } else {
                    coordinator.showSMSValidation(item: .passwordRecovery(account: ""))
                }
            }
        }
        
        return Output()
    }
}
