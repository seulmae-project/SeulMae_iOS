//
//  MemberViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MemberViewModel: ViewModel {
    
    struct Input {
        let onLoad: Signal<()>
    }
    
    struct Output {
        let memberInfo: Driver<MemberInfo>
    }
    
    // MARK: - Dependency
    
    //    private let coordinator: AuthFlowCoordinator
    
    private let workplaceIdentifier: Int = 0
    private let memberIdentifier: Member.ID = 0
    
    private let workplaceUseCase: WorkplaceUseCase = DefaultWorkplaceUseCase(workplaceRepository: DefaultWorkplaceRepository())
    
    private let noticeUseCase: NoticeUseCase = DefaultNoticeUseCase(noticeRepository: DefaultNoticeRepository(network: MainNetworking()))
    
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
        
        // MARK: Member Info
        
        let memberInfo = input.onLoad
            .flatMap { [unowned self] _ in
                self.workplaceUseCase.fetchMemberInfo(mmemberIdentifier: self.memberIdentifier)
                    .asDriver()
            }
        
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
            memberInfo: memberInfo
        )
    }
}
