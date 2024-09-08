//
//  MemberInfoViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MemberInfoViewModel: ViewModel {
    
    struct Input {
        let onLoad: Signal<()>
    }
    
    struct Output {
        let memberInfo: Driver<MemberProfile>
    }
    
    // MARK: - Dependency
    
    private let member: Member
    
    private let coordinator: MainFlowCoordinator
    
    private let workplaceIdentifier: Int = 0
    private let memberIdentifier: Member.ID = 0
    
    private let workplaceUseCase: WorkplaceUseCase
    // private let noticeUseCase: NoticeUseCase
    
    // MARK: - Life Cycle
    
    init(
        dependency: (
            member: Member,
            coordinator: MainFlowCoordinator,
            workplaceUseCase: WorkplaceUseCase
            //            validationService: ValidationService,
            //            wireframe: Wireframe
        )
    ) {
        self.member = dependency.member
        self.coordinator = dependency.coordinator
        self.workplaceUseCase = dependency.workplaceUseCase
        //        self.validationService = dependency.validationService
        //        self.wireframe = dependency.wireframe
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
        
        // MARK: Member Info
        
//        let memberInfo = workplaceUseCase.fetchMemberInfo(memberIdentifier: self.memberIdentifier)
//            .asDriver()
//        input.onLoad
//            .flatMap { [unowned self] _ in
//                return
//            }

        
        // MARK: Member Work Log
        
//        _ = input.onLoad
//            .flatMap { [unowned self] _ in
//                self.workplaceUseCase.fetch
//            }

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
            memberInfo: .empty() // memberInfo
        )
    }
}
