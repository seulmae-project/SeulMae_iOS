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
import AuthenticationServices

final class SigninViewModel: ViewModel {
    
    struct Input {
        let userID: Driver<String>
        let password: Driver<String>
        let signin: Signal<()>
        let kakaoSignin: Signal<()>
        let appleSignin: Signal<ASAuthorizationAppleIDCredential>
        let accountRecovery: Signal<()>
        let signup: Signal<()>
    }
    
    struct Output {
        let loading: Driver<Bool>
    }
    
    // MARK: - Dependency
    
    private let coordinator: AuthFlowCoordinator
    private let authUseCase: AuthUseCase
    private let workplaceUseCase: WorkplaceUseCase
    private let validationService: ValidationService
    private let wireframe: Wireframe
    
    // MARK: - Life Cycle
    
    init(
        dependencies: (
            coordinator: AuthFlowCoordinator,
            authUseCase: AuthUseCase,
            workplaceUseCase: WorkplaceUseCase,
            validationService: ValidationService,
            wireframe: Wireframe
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.authUseCase = dependencies.authUseCase
        self.workplaceUseCase = dependencies.workplaceUseCase
        self.validationService = dependencies.validationService
        self.wireframe = dependencies.wireframe
    }
        
    @MainActor func transform(_ input: Input) -> Output {
        let tracker = ActivityIndicator()
        let loading = tracker.asDriver()
        
        // MARK: - Signin
        
        let userIDAndPassword = Driver.combineLatest(input.userID, input.password) { (userID: $0, password: $1) }
        
        let signedIn = input.signin.withLatestFrom(userIDAndPassword)
            .flatMapLatest { [weak self] pair -> Driver<Bool> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.authUseCase
                    .signin(email: pair.userID, password: pair.password, fcmToken: "")
                    .trackActivity(tracker)
                    .asDriver { error in
                        let message: String
                        message = "error"
                        return strongSelf.wireframe
                            .promptFor(message, cancelAction: "OK", actions: [])
                            .map { _ in false }
                            .asDriver(onErrorDriveWith: .empty())
                    }
            }
        
        let isFirst = signedIn
            .filter { $0 }
            .flatMapLatest { [weak self] _ -> Driver<Bool> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.workplaceUseCase
                    .fetchWorkplaces()
                    .map { $0.isEmpty }
                    .asDriver()
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
        let appleToken = input.appleSignin
            .map { String(data: $0.identityToken!, encoding: .utf8)! }
            .map { (type: SocialSigninType.apple, token: $0) }
        
        let kakaoToken = Signal<(type: SocialSigninType, token: String)>.empty()
        
        let tokens = Signal.merge(appleToken, kakaoToken)
    
        let credential = tokens.flatMapLatest { [weak self] pair -> Driver<Credentials> in
            guard let strongself = self else { return .empty() }
            return strongself.authUseCase
                .socialSignin(type: pair.type, token: pair.token)
                .trackActivity(tracker)
                .asDriver()
        }
        
        // MARK: - Coordinator Logic
        
        // handle signin credential
        Task {
            for await credential in credential.values {
                let isUserHaveProfile = !(credential.role == "guest")
                if isUserHaveProfile {
                    // 메인 화면 이동
                } else {
                    coordinator.showProfileSetup(request: SignupRequest())
                }
            }
        }
        
        Task {
            for await _ in input.accountRecovery.values {
                coordinator.showAccountRecoveryOption()
            }
        }
        
        Task {
            for await isFirst in isFirst.values {
                if isFirst {
                    coordinator.startMain()
                } else {
                    coordinator.showSearchWorkplace()
                }
            }
        }
            
//        Task {
//            for await item in input.validateSMS.values {
//                coordinator.showSMSValidation(item: item)
//            }
//        }
        
        Task {
            for await _ in input.signup.values {
                coordinator.showSMSValidation(item: .signup)
            }
        }
        
//        Task {
//            for await credentialOption in input.credentialOption.values {
//                if (credentialOption == .account) {
//                    coordinator.showSMSValidation(item: .accountRecovery)
//                } else {
//                    coordinator.showSMSValidation(item: .passwordRecovery(account: ""))
//                }
//            }
//        }
        
        return Output(loading: loading)
    }
}
