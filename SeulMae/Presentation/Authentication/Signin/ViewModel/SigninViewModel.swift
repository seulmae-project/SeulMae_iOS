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
                    .signin(accountId: pair.userID, password: pair.password)
                    .trackActivity(tracker)
                    .asDriver()
            }
        
        let hasGroup = signedIn
            .filter { $0 }
            .map { [weak self] _ -> Bool in
                guard let strongSelf = self else { return true }
                let workplaceList = strongSelf.workplaceUseCase
                    .readWorkplaceList()
                Swift.print("[Signin VM] workplaceListCount: \(workplaceList.count)")
                return !workplaceList.isEmpty
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
        
        let kakaoToken = oAuthToken.map {
            return (type: SocialSigninType.kakao, token: ($0.idToken ?? ""))
        }
            .asSignal()
        
        let tokens = Signal.merge(appleToken, kakaoToken)
    
        let isGuest = tokens.flatMapLatest { [weak self] pair -> Driver<(Bool, Bool)> in
            guard let strongself = self else { return .empty() }
            return strongself.authUseCase
                .socialSignin(type: pair.type, token: pair.token)
                .trackActivity(tracker)
                .asDriver()
        }
        
        // MARK: - Coordinator Methods
        
        Task {
            for await (isGuest, hasGroup) in isGuest.values {
                if isGuest {
                    coordinator.showProfileSetup(request: SignupRequest(), signupType: .social)
                } else {
                    // 메인 화면 이동
                    if hasGroup {
                        coordinator.startMain(isManager: false)
                    } else {
                        coordinator.showWorkplaceFinder()
                    }
                }
            }
        }
        
        Task {
            for await _ in input.accountRecovery.values {
                coordinator.showAccountRecoveryOption()
            }
        }
        
        Task {
            for await hasGroup in hasGroup.values {
                if hasGroup {
                    let workplace = workplaceUseCase.readDefaultWorkplace()
                    let isManager = workplace.isManager ?? false
                    Swift.print("[SginIn VM] isManager: \(isManager)")
                    coordinator.startMain(isManager: isManager)
                } else {
                    coordinator.showWorkplaceFinder()
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
