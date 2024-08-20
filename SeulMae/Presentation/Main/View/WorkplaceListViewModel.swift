//
//  WorkplaceListViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 8/16/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WorkplaceListViewModel: ViewModel {
    struct Input {
        let selected: Signal<()>
    }
    
    struct Output {
        let workplaces: Driver<[Workplace]>
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
        let account = UserDefaults.standard.string(forKey: "account")
        Swift.print("🥹 account: \(account!)")
        // let colums = WorkplaceTable.fetch(account: account!)
        // Swift.print("🥹 table colums: \(colums)")
        // let id = colums.first!["id"] as? Int
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
        
        return Output(
            workplaces: .empty()
        )
    }
}


   
    
