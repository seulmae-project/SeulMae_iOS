//
//  WorkScheduleDetailsViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 9/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WorkScheduleDetailsViewModel: ViewModel {
    
    // MARK: - Internal Types
    
    struct Input {
        let name: Driver<String>
        let time: Driver<String>
        let weekdays: Driver<[Int]>
        let members: Driver<Member.ID>
        let save: Signal<()>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let items: Driver<[WorkScheduleDetailsItem]>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: WorkplaceFlowCoordinator
    private let workScheduleUseCase: WorkScheduleUseCase
    private let workScheduleId: WorkSchedule.ID?
        
    // MARK: - Life Cycle
    
    init(
        dependencies: (
            coordinator: WorkplaceFlowCoordinator,
            workScheduleUseCase: WorkScheduleUseCase,
            workScheduleId: WorkSchedule.ID?
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.workScheduleUseCase = dependencies.workScheduleUseCase
        self.workScheduleId = dependencies.workScheduleId
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
        
        let items: Driver<[WorkScheduleDetailsItem]>
        if let workScheduleId {
            items = workScheduleUseCase.fetchWorkScheduleDetails(workScheduleId: workScheduleId)
                .trackActivity(indicator)
                .map { self.toItems(from: $0) }
                .asDriver()
        } else {
            items = .empty()
        }
        
        return Output(
            loading: loading,
            items: items
        )
    }
    
    func toItems(from schedule: WorkSchedule) -> [WorkScheduleDetailsItem] {
        return [
            .init(title: schedule.title),
            .init(time: schedule.startTime + "~" + schedule.endTime),
            .init(weekdays: schedule.days),
            // .init(members: workSchedule.)
        ]
    }
}
