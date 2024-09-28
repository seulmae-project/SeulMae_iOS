//
//  WorkRecordViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 9/22/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WorkRecordViewModel {
    
    struct Input {
        let onLoad: Signal<()>
        let getOffWork: Signal<()>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let item: Driver<WorkScheduleListItem>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: HomeFlowCoordinator
    private let atendanceHistoryUseCase: AttendanceHistoryUseCase
    private let workTimeCalculator: WorkTimeCalculator

    // MARK: - Life Cycle
    
    init(
        dependencies: (
            coordinator: HomeFlowCoordinator,
            atendanceHistoryUseCase :AttendanceHistoryUseCase,
            workTimeCalculator: WorkTimeCalculator
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.atendanceHistoryUseCase = dependencies.atendanceHistoryUseCase
        self.workTimeCalculator = dependencies.workTimeCalculator
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
            
        let onLoad = Signal.merge(.just(()), input.onLoad)
        
//        workTimeCalculator.calculate(
//            start: <#T##Date#>, end: <#T##Date#>, wage: <#T##Int#>)
//        
        // MARK: - Coordinator
      
        return Output(
            loading: loading,
            item: .empty()
        )
    }
}
