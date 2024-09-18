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
    
    // MARK: - Internal Types
    
    struct Input {
        let addNew: Signal<()>
        let showDetails: Signal<WorkSchedule.ID>
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
        
        let items = workScheduleUseCase.fetchWorkScheduleList()
            .trackActivity(indicator)
            .map { $0.map(WorkScheduleListItem.init(workSchedule:)) }
            .asDriver()
        
        Task {
            for await _ in input.addNew.values {
                coordinator.showWorkScheduleDetails(workScheduleId: nil)
            }
        }
        
        Task {
            for await workScheduleId in input.showDetails.values {
                coordinator.showWorkScheduleDetails(workScheduleId: workScheduleId)
            }
        }
        
        return Output(
            loading: loading,
            items: items
        )
    }
}
