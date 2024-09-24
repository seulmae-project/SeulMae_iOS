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
        let attend: Signal<AttendRequest>
        let add: Signal<AttendRequest>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let histories: Driver<[AttendanceHistory]>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: HomeFlowCoordinator
    private let attendanceUseCase: AttendanceUseCase
    private let attendanceHistoryUseCase: AttendanceHistoryUseCase
    private var disposeBag = DisposeBag()
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
        
        input.onLoad
            .emit(onNext: { _ in
                let vc = ScheduleReminderViewController(viewModel: .init(
                    dependencies: (
                        coordinator: self.coordinator,
                        attendanceUseCase: DefaultAttendanceUseCase(repository: DefaultAttendanceRepository(network: AttendanceNetworking())),
                        workTimeCalculator: WorkTimeCalculator()
                    )))
                let bottomSheet =  BottomSheetController(contentViewController: vc)
                let nav = self.coordinator.navigationController
                nav.present(bottomSheet, animated: true)
            })
            .disposed(by: disposeBag)
        
        Task {
            for await _ in input.onLoad.values {
              // TODO: viewDidLoad dispose issue
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
