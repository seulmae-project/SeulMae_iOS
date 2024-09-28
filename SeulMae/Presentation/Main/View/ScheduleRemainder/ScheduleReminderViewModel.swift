//
//  ScheduleReminderViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 9/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ScheduleReminderViewModel {
    
    struct Input {
        let onLoad: Signal<()>
        let startDate: Driver<Date>
        let endDate: Driver<Date>
        let memo: Driver<String>
        let onRequest: Signal<()> // Date
        let onWorkStart: Signal<()>
        let onRegister: Signal<()>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let item: Driver<ScheduleReminderItem>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: HomeFlowCoordinator
    private let workplaceUseCase: WorkplaceUseCase
        
    // MARK: - Life Cycle
    
    init(
        dependencies: (
            coordinator: HomeFlowCoordinator,
            workplaceUseCase: WorkplaceUseCase
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.workplaceUseCase = dependencies.workplaceUseCase
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
            
        let onLoad = Signal.merge(.just(()), input.onLoad)
        
        let wage = onLoad.flatMapLatest { [weak self] _ -> Driver<Int> in
            guard let strongSelf = self else { return .empty() }
            return .just(10_000)
        }
        
        let workScheduleList = onLoad.flatMapLatest { [weak self] _ -> Driver<[WorkSchedule]> in
            guard let strongSelf = self else { return .empty() }
            return .just([])
        }
        
        let dateAndWage = Driver.combineLatest(input.startDate, input.endDate, wage)
        
//        let isAttend = input.onRequest.withLatestFrom(dateAndWage)
//            .flatMapLatest { [weak self] (start, end, wage) -> Driver<Bool> in
//                guard let strongSelf = self else { return .empty() }
//                let request = strongSelf.workTimeCalculator
//                    .calculate(start: start, end: end, wage: wage)
//                return strongSelf.attendanceUseCase
//                    .attend(request: request)
//                    .trackActivity(indicator)
//                    .asDriver()
//            }
//        
//        Task {
//            for await _ in isAttend.values {
//                
//            }
//        }
        
        // MARK: - Coordinator
        
        Task {
            for await _ in input.onWorkStart.values {
                coordinator.startWorkTimeRecord()
            }
        }
        
        Task {
            for await _ in input.onRegister.values {
                
            }
        }
      
        return Output(
            loading: loading,
            item: .empty()// item
        )
    }
}
