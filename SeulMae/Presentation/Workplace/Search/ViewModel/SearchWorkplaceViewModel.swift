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
        let item: Driver<Item>
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
        
        let onLoad = Signal.merge(.just(()), input.onLoad)
        
        let fetched =  onLoad.flatMapLatest { [weak self] _ -> Driver<Item> in
            guard let strongSelf = self else {
                return .empty()
            }
            
            return strongSelf.workplaceUseCase
                .fetchWorkplaces(keyword: "")
                .trackActivity(tracker)
                .map(Item.init(workplaceList:))
                .asDriver()
        }
        
        let searched = input.query
            .withLatestFrom(fetched) { (query: $0, item: $1) }
            .map { pair in
                if (pair.query.isEmpty) { return pair.item }
                let matched = pair.item.workplaceList.filter {
                    let name = $0.name.lowercased()
                    let address = $0.mainAddress.lowercased()
                    return (name + address).contains(pair.query.lowercased())
                }
                return Item(workplaceList: matched)
            }
        
        let item = Driver.merge(fetched, searched)
        
        // MARK: - Coordinator Logic
        
        Task {
            for await selected in input.selected.values {
                coordinator.showWorkplaceDetails(workplaceID: selected.id)
            }
        }
        
        return Output(
            loading: loading,
            item: item
        )
    }
}

