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
    typealias Item = WorkplaceFinderItem

    struct Input {
        let onLoad: Signal<()>
        let onRefresh: Signal<()>
        let search: Signal<()>
        let create: Signal<()>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let items: Driver<[Item]>
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
        let tracker = ActivityIndicator()
        let loading = tracker.asDriver()
        
        let onLoad = Signal.merge(.just(()), input.onLoad, input.onRefresh)
        let items = onLoad.flatMapLatest { [weak self] _ -> Driver<[Item] >in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.workplaceUseCase
                .fetchJoinedWorkplaceList()
                .map { $0.map(Item.init(workplace: )) }
                .asDriver()
        }
        
        // MARK: - Coordinator Logic
        
        Task {
            for await _ in input.search.values {
                coordinator.showSearchWorkPlace()
            }
        }
        
        Task {
            for await _ in input.create.values {
                coordinator.showAddNewWorkplace()
            }
        }
        
        return Output(
            loading: loading,
            items: items
        )
    }
}

