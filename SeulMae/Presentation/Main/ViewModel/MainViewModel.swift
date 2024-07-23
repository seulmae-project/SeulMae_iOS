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
        let onMemberTap: Signal<Member>
        let onBarButtonTap: Signal<()>
    }
    
    struct Output {
        let members: Driver<[Member]>
        let notices: Driver<[Notice]>
    }
    
    // MARK: - Dependency
    
    private let coordinator: MainFlowCoordinator
    
    // TODO: workplace 변경시 변경되어야 함 userInfo?
    private let workplaceIdentifier: Int = 0
    
    private let workplaceUseCase: WorkplaceUseCase
    
    private let noticeUseCase: NoticeUseCase
//
//    private let validationService: ValidationService
//
//    private let wireframe: Wireframe
        
    // MARK: - Life Cycle
    
    init(
        dependency: (
            coordinator: MainFlowCoordinator,
            workplaceUseCase: WorkplaceUseCase,
            noticeUseCase: NoticeUseCase
            
//            validationService: ValidationService,
//            wireframe: Wireframe
        )
    ) {
        self.coordinator = dependency.coordinator
        self.workplaceUseCase = dependency.workplaceUseCase
        self.noticeUseCase = dependency.noticeUseCase
//        self.validationService = dependency.validationService
//        self.wireframe = dependency.wireframe
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
        
        let members = workplaceUseCase.fetchMemberList(workplaceIdentifier: workplaceIdentifier)
            .asDriver()
        
        let notices = noticeUseCase.fetchMainNoticeList(workplaceIdentifier: workplaceIdentifier)
            .asDriver()
       
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
        
        Task {
            for await member in input.onMemberTap.values {
                coordinator.showMemberInfo(member: member)
            }
        }
        
        Task {
            for await _ in input.onBarButtonTap.values {
                coordinator.showNotiList(workplaceIdentifier: 0)
            }
        }
        
        
//        let nextStepEnabled = Driver.combineLatest(
//            validatedSMS, verifiedCode, loading) { validated, verified, loading in
//                validated &&
//                verified &&
//                !loading
//            }
//            .distinctUntilChanged()
//        
        return Output(
            members: members,
            notices: notices
        )
    }
}
