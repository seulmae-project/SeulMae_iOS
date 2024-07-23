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
        let onItemTap: Signal<Notice.ID>
    }
    
    struct Output {
        let items: Driver<[NotiListItem]>
    }
    
    // MARK: - Dependency
    
    private let coordinator: MainFlowCoordinator
    
    private let workplaceUseCase: WorkplaceUseCase
    
    private let noticeUseCase: NoticeUseCase
    
    private let workplaceIdentifier: Workplace.ID
        
    // MARK: - Life Cycle
    
    init(
        dependency: (
            workplaceIdentifier: Workplace.ID,
            coordinator: MainFlowCoordinator,
            workplaceUseCase: WorkplaceUseCase,
            noticeUseCase: NoticeUseCase
        )
    ) {
        self.workplaceIdentifier = dependency.workplaceIdentifier
        self.coordinator = dependency.coordinator
        self.workplaceUseCase = dependency.workplaceUseCase
        self.noticeUseCase = dependency.noticeUseCase
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
   
        let size = 10
        let notices = noticeUseCase.fetchAllNotice(workplaceIdentifier: workplaceIdentifier, page: 0, size: size)
            .map { $0.map(NotiListItem.init(notice:)) }
            .asDriver()
       
        // MARK: Flow Logic
        
        Task {
            for await noticeIdentifier in input.onItemTap.values {
                
            }
        }
        

        return Output(
            items: notices
        )
    }
}
