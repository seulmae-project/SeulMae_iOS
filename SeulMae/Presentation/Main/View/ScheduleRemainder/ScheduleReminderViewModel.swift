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
    
    typealias Item = ScheduleReminderItem
    
    struct Input {
        let onLoad: Signal<()>
        let onWorkStart: Signal<()>
        let onRegister: Signal<()>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let item: Driver<Item>
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
        let item = onLoad.flatMapLatest { [weak self] _ -> Driver<Item> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.workplaceUseCase
                .fetchMyInfo()
                .trackActivity(indicator)
                .map(\.workScheduleList)
                .map(Item.init(workScheduleList:))
                .asDriver()
        }
        
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
            item: item
        )
    }
}
