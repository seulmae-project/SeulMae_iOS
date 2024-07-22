//
//  NotiListViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 7/22/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NotiListViewModel: ViewModel {
    struct Input {

    }
    
    struct Output {
        let items: Driver<[NotiListItem]>
    }
    
    // MARK: - Dependency
    
    private let coordinator: MainFlowCoordinator
    
    private let workplaceUseCase: WorkplaceUseCase
    
    private let noticeUseCase: NoticeUseCase
        
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
        
   
//        
//        let notices = noticeUseCase.fetchMainNoticeList(workplaceIdentifier: workplaceIdentifier)
//            .asDriver()
       
        // MARK: Flow Logic

        return Output(
            items: .empty()
        )
    }
}
