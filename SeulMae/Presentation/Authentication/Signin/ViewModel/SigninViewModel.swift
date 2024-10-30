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
        let onLoad: Signal<()>
        let onRefresh: Signal<()>
        let id: Driver<String>
        let pw: Driver<String>
        let signin: Signal<()>
        let kakaoSignin: Signal<()>
        let appleSignin: Signal<ASAuthorizationAppleIDCredential>
        let idRecovery: Signal<()>
        let pwRecovery: Signal<()>
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
        
        let idAndPw = Driver.combineLatest(input.id, input.pw) { (id: $0, pw: $1) }
        let signedInResult = input.signin
            .withLatestFrom(idAndPw)
            .withUnretained(self)
            .flatMapLatest { (self, pair) -> Driver<Credentials> in
                return self.authUseCase
                    .signin(accountId: pair.id, password: pair.pw)
                    .trackActivity(tracker)
                    .asDriver { error in
                        Swift.print("error: \(error)")
                        DefaultWireframe.presentAlert("아이디와 패스워드를 확인해주세요")
                        return .empty()
                    }
            }

        // MARK: - Kakao Signin
        
        let oAuthToken = input.kakaoSignin
            .flatMapLatest { _ -> Signal<OAuthToken> in
                let token = UserApi.isKakaoTalkLoginAvailable() ?
                 UserApi.shared.rx.loginWithKakaoTalk() : UserApi.shared.rx.loginWithKakaoAccount()
                return token.asSignal()
            }

        // Merge received token
        let appleToken = input.appleSignin
            .map { String(data: $0.identityToken!, encoding: .utf8)! }
            .map { (type: SocialSigninType.apple, token: $0) }
        let kakaoToken = oAuthToken.map { tokens in (type: SocialSigninType.kakao, token: (tokens.idToken ?? "")) }

        // Sign in with token
        let tokens = Signal.merge(appleToken, kakaoToken)
        let socialSignedInResult = tokens.withUnretained(self)
            .flatMapLatest { (self, pair) -> Driver<Credentials> in
            return self.authUseCase
                .socialSignin(type: pair.type, token: pair.token)
                .trackActivity(tracker)
                .asDriver()
        }
        
        // Merge signed in results
        let credentials = Driver.merge(signedInResult, socialSignedInResult)

        // Merge id, pw recovery events
        let idRecovery = input.idRecovery
            .map { _ in SMSVerificationType.idRecovery }
        let pwRecovery = input.pwRecovery
            .map { _ in SMSVerificationType.pwRecovery }
        let signup = input.signup
            .map { _ in SMSVerificationType.signUp }
        let smsVerificationType = Signal.merge(idRecovery, pwRecovery, signup)

        // MARK: - Coordinator Methods

        Task {
            for await credentials in credentials.values {
                if credentials.isGuest {
                    coordinator.showProfileSetup(request: SignupRequest(), signupType: .social)
                } else {
                    if !(credentials.workplace).isEmpty {
                        let isManager: Bool
                        if let defaultWorkplaceId = credentials.defaultWorkplaceId {
                            isManager = credentials.workplace.first(where: { $0.id == defaultWorkplaceId })?.isManager ?? false
                        } else {
                            isManager = credentials.workplace.first!.isManager ?? false
                        }
                        coordinator.startMain(isManager: isManager)
                    } else {
                        coordinator.showWorkplaceFinder()
                    }
                }
            }
        }

        Task {
            for await item in smsVerificationType.values {
                coordinator.showSMSValidation(item: item)
            }
        }
        
        return Output(loading: loading)
    }
}
