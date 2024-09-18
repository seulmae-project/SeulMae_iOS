//
//  WorkScheduleListViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 9/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WorkScheduleListViewModel: ViewModel {
    struct Input {
        
    }
    
    struct Output {
        let loading: Driver<Bool>
        let items: Driver<[WorkScheduleListItem]>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: WorkplaceFlowCoordinator
    private let workScheduleUseCase: WorkScheduleUseCase
        
    // MARK: - Life Cycle
    
    init(
        dependencies: (
            coordinator: WorkplaceFlowCoordinator,
            workScheduleUseCase: WorkScheduleUseCase
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.workScheduleUseCase = dependencies.workScheduleUseCase
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
      
        
        return Output(
            loading: loading,
            items: .empty()
        )
    }
}
