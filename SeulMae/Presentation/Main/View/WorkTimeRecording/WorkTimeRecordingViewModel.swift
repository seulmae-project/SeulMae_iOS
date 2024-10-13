//
//  WorkTimeRecordingViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 9/22/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WorkTimeRecordingViewModel {
    
    struct Input {
        let onLoad: Signal<()>
        let getOffWork: Signal<()>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let item: Driver<WorkTimeRecordingItem>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: HomeFlowCoordinator
    private let workplaceUseCase: WorkplaceUseCase
    private let atendanceHistoryUseCase: AttendanceHistoryUseCase
    private let workTimeCalculator: AttendanceService
    
    // MARK: - Life Cycle
    
    init(
        dependencies: (
            coordinator: HomeFlowCoordinator,
            workplaceUseCase: WorkplaceUseCase,
            atendanceHistoryUseCase :AttendanceHistoryUseCase,
            workTimeCalculator: AttendanceService
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.workplaceUseCase = dependencies.workplaceUseCase
        self.atendanceHistoryUseCase = dependencies.atendanceHistoryUseCase
        self.workTimeCalculator = dependencies.workTimeCalculator
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
        
        let onLoad = Signal.merge(.just(()))
        
        let item = onLoad.flatMapLatest { [weak self] _ in
            guard let strongSelf = self else {
                return Driver<WorkTimeRecordingItem>.empty()
            }
            
            return strongSelf.workplaceUseCase
                .fetchMyInfo()
                .trackActivity(indicator)
                .asDriver()
                .flatMapLatest { profile in
                    let item = strongSelf.workTimeCalculator
                    item.start(workSchedule: profile.workScheduleList.first!)
                    return item.asDriver()
                }
        }
        
        // MARK: - Coordinator
        
        return Output(
            loading: loading,
            item: item
        )
    }
}
