//
//  WorkplaceFinderViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 8/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WorkplaceFinderViewModel: ViewModel {
    struct Input {
        var search: Signal<()>
        var create: Signal<()>
    }
    
    struct Output {
    }
    
    // MARK: - Dependencies
    
    private let coordinator: MainFlowCoordinator
    private let workplaceUseCase: WorkplaceUseCase
    
    // MARK: - Life Cycle
    
    init(
        dependencies: (
            coordinator: MainFlowCoordinator,
            workplaceUseCase: WorkplaceUseCase
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.workplaceUseCase = dependencies.workplaceUseCase
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        
        // MARK: - Coordinator Logic
        
        Task {
            for await _ in input.search.values {
                // coordinator.showSearchWorkPlace()
            }
        }
        
        Task {
            for await _ in input.create.values {
                // coordinator.showAddNewWorkplace()
            }
        }
        
        return Output()
    }
}

