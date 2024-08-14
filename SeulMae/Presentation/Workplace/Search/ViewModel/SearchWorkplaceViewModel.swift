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
    struct Input {
        var onLoad: Signal<()>
        var query: Driver<String>
        var onSearch: Signal<()>
        var selected: Signal<SearchWorkplaceViewController.Item>
        var addNewPlace: Signal<()>
    }
    
    struct Output {
        let workplaces: Driver<[Workplace]>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: MainFlowCoordinator
    
    private let workplaceUseCase: WorkplaceUseCase
    
//    private let validationService: ValidationService
//    
//    private let wireframe: Wireframe

    
    // MARK: - Life Cycle
    
    init(
        dependencies: (
            coordinator: MainFlowCoordinator,
            workplaceUseCase: WorkplaceUseCase
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.workplaceUseCase = dependencies.workplaceUseCase
//        self.validationService = dependency.validationService
//        self.wireframe = dependency.wireframe
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let workplaces = Signal.just(())
            .flatMap { [weak self] _ -> Driver<[Workplace]> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.workplaceUseCase
                    .fetchWorkplaces(keyword: "")
                    .asDriver()
            }
        
        
        
        
        // MARK: - Coordinator Logic
        
        Task {
            for await selected in input.selected.values {
                coordinator.showWorkplaceDetails(workplaceID: selected.id)
            }
        }
        
        Task {
            for await _ in input.addNewPlace.values {
                coordinator.showAddNewWorkplace()
            }
        }
        
        return Output(
            workplaces: workplaces
        )
    }
}

