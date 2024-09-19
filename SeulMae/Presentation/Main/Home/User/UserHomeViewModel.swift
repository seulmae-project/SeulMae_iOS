//
//  UserHomeViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 9/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class UserHomeViewModel {
    struct Input {
        let onLoad: Signal<()>
        let refresh: Signal<()>
        let showNotis: Signal<()>
        let showDetails: Signal<()>
        let attend: Signal<()>
        let add: Signal<()>
    }
    
    struct Output {
        let loading: Driver<Bool>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: HomeFlowCoordinator
    private let attendnaceUseCase: AttendanceUseCase
        
    // MARK: - Life Cycle
    
    init(
        dependencies: (
            coordinator: HomeFlowCoordinator,
            attendnaceUseCase: AttendanceUseCase
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.attendnaceUseCase = dependencies.attendnaceUseCase
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
    
        
        return Output(
            loading: loading
        )
    }
}
