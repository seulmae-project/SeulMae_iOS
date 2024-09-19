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
        let attend: Signal<AttendRequset>
        let add: Signal<AttendRequset>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let histories: Driver<[AttendanceHistory]>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: HomeFlowCoordinator
    private let attendanceUseCase: AttendanceUseCase
    private let attendanceHistoryUseCase: AttendanceHistoryUseCase
        
    // MARK: - Life Cycle
    
    init(
        dependencies: (
            coordinator: HomeFlowCoordinator,
            attendanceUseCase: AttendanceUseCase,
            attendanceHistoryUseCase: AttendanceHistoryUseCase
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.attendanceUseCase = dependencies.attendanceUseCase
        self.attendanceHistoryUseCase = dependencies.attendanceHistoryUseCase
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
            
        let initial = Signal.just(())
        
        let r = Signal.merge(initial, input.onLoad, input.refresh)
        
        let histories = r.flatMapLatest { [weak self] _ -> Driver<[AttendanceHistory]> in
            guard let strongSelf = self else { return .empty() }
            let currentDate = Date()
            let year = Calendar.current.component(.year, from: currentDate)
            let month = Calendar.current.component(.month, from: currentDate)
            return strongSelf.attendanceHistoryUseCase
                .fetchAttendanceCalendar(year: year, month: month)
                .trackActivity(indicator)
                .asDriver()
        }
    
        let isAttend = input.attend
            .flatMapLatest { [weak self] request -> Driver<Bool> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.attendanceUseCase
                    .attend(request: request)
                    .trackActivity(indicator)
                    .asDriver()
            }
        
        
        Task {
            for await _ in isAttend.values {
                
            }
        }
        
        
    
        
        
        // MARK: - Coordinator
        
        Task {
            for await id in input.showDetails.values {
                // coordinator.
            }
        }
        
        Task {
            for await _ in input.showNotis.values {
                coordinator.showNotiList()
            }
        }
        
        return Output(
            loading: loading,
            histories: histories
        )
    }
}
