//
//  AnnounceViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 8/31/24.
//

import Foundation
import RxSwift
import RxCocoa

final class AnnounceListViewModel: ViewModel {
    struct Input {
        
    }
    
    struct Output {
        let items: Driver<AnnounceListItem>
    }
    
    private let coordinator: MainFlowCoordinator
    private let noticeUseCase: NoticeUseCase
    private let workplaceId: Workplace.ID
    
    init(
        dependencies: (
            coordinator: MainFlowCoordinator,
            noticeUseCase: NoticeUseCase,
            workplaceId: Workplace.ID
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.noticeUseCase = dependencies.noticeUseCase
        self.workplaceId = dependencies.workplaceId
    }
    
    @MainActor
    func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let isLoading = indicator.asDriver()
        
        
        
        // MARK: -
        
        return Output(
            items: .empty()
        )
    }
}
