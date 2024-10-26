//
//  SearchWorkplaceViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchWorkplaceViewModel: ViewModel {
    struct Input {
        let onLoad: Signal<()>
        let onRefresh: Signal<()>
        let query: Driver<String>
        let onSearch: Signal<()>
        let onItemTap: Signal<SearchWorkplaceItem>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let items: Driver<[SearchWorkplaceItem]>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: FinderFlowCoordinator
    private let workplaceUseCase: WorkplaceUseCase
    
    // MARK: - Life Cycle
    
    init(
        dependencies: (
            coordinator: FinderFlowCoordinator,
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
        let fetched =  onLoad.withUnretained(self)
            .flatMapLatest { (self, _) -> Driver<[SearchWorkplaceItem]> in
            self.workplaceUseCase
                .fetchWorkplaces(keyword: "")
                .trackActivity(tracker)
                .map { $0.map(SearchWorkplaceItem.query(_:)) }
                .asDriver()
        }
        
        let matched = input.query
            .withLatestFrom(fetched) { (query: $0, items: $1) }
            .map { pair in
                if (pair.query.isEmpty) { return pair.items }
                return pair.items.filter {
                    let name = $0.query!.lowercased()
                    // let address = $0.placeAddress.lowercased()
                    return (name).contains(pair.query.lowercased())
                }
            }
        
        let items = Driver.merge(fetched, matched)
        
        // MARK: - Coordinator Logic
        
        Task {
            for await selected in input.onItemTap.values {
                coordinator.showWorkplaceDetails(workplaceID: selected.workplaceId!)
            }
        }
        
        return Output(
            loading: loading,
            items: items
        )
    }
}

