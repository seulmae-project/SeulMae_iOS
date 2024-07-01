//
//  MainViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 6/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel: ViewModel {
    
    struct Input {
        let showWorkplace: Signal<()>
        let changeWorkplace: Signal<()>
        let showRemainders: Signal<()>
        let showMemberDetail: Signal<()>
        let showNotices: Signal<()>
        let workStart: Signal<()>
        let addWorkLog: Signal<()>
    }
    
    struct Output {
    
    }
    
    // MARK: - Dependency
    
//    private let coordinator: AuthFlowCoordinator
//    
//    private let authUseCase: AuthUseCase
//    
//    private let validationService: ValidationService
//
//    private let wireframe: Wireframe
        
    // MARK: - Life Cycle
    
    init(
        dependency: (
//            coordinator: AuthFlowCoordinator,
//            authUseCase: AuthUseCase,
//            validationService: ValidationService,
//            wireframe: Wireframe
        )
    ) {
//        self.coordinator = dependency.coordinator
//        self.authUseCase = dependency.authUseCase
//        self.validationService = dependency.validationService
//        self.wireframe = dependency.wireframe
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
       
        // MARK: Code Verification
        
//        let validatedCode = input.code
//            .map { $0.count == 6 }
//        let codeVerificationEnabled = Driver.combineLatest(
//            validatedCode, loading) { code, loading in
//                code &&
//                !loading
//            }
//            .distinctUntilChanged()
//        
//        let verifiedCode = input.verifyCode.withLatestFrom(input.code)
//            .flatMapLatest { [weak self] code -> Driver<Bool> in
//                guard let strongSelf = self else { return .empty() }
//                return strongSelf.authUseCase
//                    .codeVerification(code)
//                    .trackActivity(indicator)
//                    .asDriver(onErrorJustReturn: false)
//            }
//            .startWith(false)
//        
        // MARK: Flow Logic
        
//        let nextStepEnabled = Driver.combineLatest(
//            validatedSMS, verifiedCode, loading) { validated, verified, loading in
//                validated &&
//                verified &&
//                !loading
//            }
//            .distinctUntilChanged()
//        
//        Task {
//            for await _ in input.nextStep.values {
//                coordinator.showAccountSetup(request: SignupRequest())
//            }
//        }
        
        return Output(
       
        )
    }
}
