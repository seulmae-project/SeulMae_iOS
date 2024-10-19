//
//  SearchWorkplaceViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import Foundation

import Foundation
import RxSwift
import RxCocoa

final class SearchWorkplaceViewModel: ViewModel {
    typealias Item = SearchWorkplaceItem
    
    struct Input {
        var onLoad: Signal<()>
        var query: Driver<String>
        var onSearch: Signal<()>
        var selected: Signal<SearchWorkplaceViewController.Item>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let items: Driver<[Item]>
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
        
        let onLoad = Signal.merge(.just(()), input.onLoad)
        
        let fetched =  onLoad.flatMapLatest { [weak self] _ -> Driver<[Item]> in
            guard let strongSelf = self else {
                return .empty()
            }
            
            return strongSelf.workplaceUseCase
                .fetchWorkplaces(keyword: "")
                .trackActivity(tracker)
                .map { $0.map(Item.init(workplace:)) }
                .asDriver()
        }
        
        let matched = input.query
            .withLatestFrom(fetched) { (query: $0, items: $1) }
            .map { pair in
                if (pair.query.isEmpty) { return pair.items }
                return pair.items.filter {
                    let name = $0.placeName.lowercased()
                    let address = $0.placeAddress.lowercased()
                    return (name + address).contains(pair.query.lowercased())
                }
            }
        
        let items = Driver.merge(fetched, matched)
        
        // MARK: - Coordinator Logic
        
        Task {
            for await selected in input.selected.values {
                coordinator.showWorkplaceDetails(workplaceID: selected.id)
            }
        }
        
        return Output(
            loading: loading,
            items: items
        )
    }
}

