//
//  AttHistoriesViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 11/13/24.
//

import Foundation
import RxSwift
import RxCocoa

class AttHistoriesViewModel {

    // MARK: - Internal Types

    struct Input {
        let onLoad: Signal<()>
        let onRefresh: Signal<()>
        let onSearch: Signal<()>
        let onFilter: Signal<()>
        let showDetails: Signal<Int>
    }

    struct Output {
        let loading: Driver<Bool>
        let workplaceInfo: Driver<Workplace>
        let attHistories: Driver<[AttendanceHistory]>
    }

    // MARK: - Dependencies

    private let coordinator: HomeFlowCoordinator
    private let workplaceUseCase: WorkplaceUseCase
    private let attendnaceUseCase: AttendanceUseCase
    private let attendnaceHistoryUseCase: AttendanceHistoryUseCase
    private let workScheduleUseCase: WorkScheduleUseCase

    // MARK: - Life Cycle Methods

    init(
        dependencies: (
            coordinator: HomeFlowCoordinator,
            workplaceUseCase: WorkplaceUseCase,
            attendnaceUseCase: AttendanceUseCase,
            attendnaceHistoryUseCase: AttendanceHistoryUseCase,
            workScheduleUseCase: WorkScheduleUseCase
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.workplaceUseCase = dependencies.workplaceUseCase
        self.attendnaceUseCase = dependencies.attendnaceUseCase
        self.attendnaceHistoryUseCase = dependencies.attendnaceHistoryUseCase
        self.workScheduleUseCase = dependencies.workScheduleUseCase
    }

    @MainActor func transform(_ input: Input) -> Output {
        let tracker = ActivityIndicator()
        let loading = tracker.asDriver()
        let onLoad = Signal.merge(input.onLoad, input.onRefresh)

        // fetch current workplace details
        let workplaceInfo = onLoad.withUnretained(self)
            .flatMapLatest { (self, _) -> Driver<Workplace> in
                return self.workplaceUseCase.fetchMyWorkplaceDetail()
                    .trackActivity(tracker)
                    .asDriver()
            }

        let today = onLoad.map { _ in Date.ext.now }

        let attHistories = today.withUnretained(self)
            .flatMapLatest { (self, date) -> Driver<[AttendanceHistory]> in
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month], from: date)
                return self.attendnaceHistoryUseCase
                    .fetchAttendanceHistories(year: components.year!, month: components.month!, page: 0, size: 30)
                    .trackActivity(tracker)
                    .asDriver()
            }

        return Output(
            loading: loading,
            workplaceInfo: workplaceInfo,
            attHistories: attHistories
        )
    }
}
