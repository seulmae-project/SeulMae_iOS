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
    
    // MARK: - Internal Types

    struct Input {
        let onLoad: Signal<()>
        let refresh: Signal<()>
        let showAlarmList: Signal<()>
        let showAttendanceDetails: Signal<()>
        let onStartRecording: Signal<()>
        let onSaveRecording: Signal<()>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let items: Driver<[UserHomeItem]>
        let isStartRecording: Driver<Bool>
        let isSaveRecording: Driver<Bool>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: HomeFlowCoordinator
    private let workplaceUseCase: WorkplaceUseCase
    private let attendanceUseCase: AttendanceUseCase
    private let attendanceHistoryUseCase: AttendanceHistoryUseCase

    // MARK: - Life Cycle Methods

    init(
        dependencies: (
            coordinator: HomeFlowCoordinator,
            workplaceUseCase: WorkplaceUseCase,
            attendanceUseCase: AttendanceUseCase,
            attendanceHistoryUseCase: AttendanceHistoryUseCase
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.workplaceUseCase = dependencies.workplaceUseCase
        self.attendanceUseCase = dependencies.attendanceUseCase
        self.attendanceHistoryUseCase = dependencies.attendanceHistoryUseCase
    }
    
    func transform(_ input: Input) -> Output {
        let tracker = ActivityIndicator()
        let loading = tracker.asDriver()
        let onLoad = Signal.merge(input.onLoad, input.refresh)

        // Fetch my profile info
        let myProfile = onLoad.withUnretained(self)
            .flatMapLatest { (self, _) -> Driver<MemberProfile> in
            return self.workplaceUseCase.fetchMyInfo()
                .trackActivity(tracker)
                .asDriver()
        }

        let workplace = onLoad.withUnretained(self)
            .flatMapLatest { (self, _) -> Driver<Workplace> in
                return self.workplaceUseCase
                    .fetchMyWorkplaceDetail()
                    .trackActivity(tracker)
                    .asDriver()
            }


        let workplaces = onLoad.withUnretained(self)
            .flatMapLatest { (self, _) -> Driver<[UserHomeItem]> in
                return self.workplaceUseCase
                    .fetchJoinedWorkplaceList()
                    .trackActivity(tracker)
                    .map { $0.map(UserHomeItem.init(workplace:)) }
                    .asDriver(onErrorJustReturn: [])
            }

        let overview = Driver.combineLatest(myProfile, workplace) {
            (profile: $0, workplace: $1) }
            .map(UserHomeItem.init(profile:workplace:))
            .map { [$0] }

        // Start recording the time for attendance
        let isStartRecording = input.onStartRecording
            .withUnretained(self)
            .map { (self, _) in self.attendanceUseCase.attend() }
            .trackActivity(tracker)
            .asDriver()

        let _ = myProfile.map(\.baseWage)

        // Fetch this month attendance histories
        let thisMonthHistories = onLoad.map { _ in Date.ext.now }
            .withUnretained(self)
            .flatMapLatest { (self, now) -> Driver<[AttendanceHistory]> in
                self.attendanceHistoryUseCase
                    .fetchAttendanceCalendar(date: now)
                    .trackActivity(tracker)
                    .asDriver()
            }

        // Merge attendance histories
        let histories = thisMonthHistories
            .map(UserHomeItem.init(histories:))
            .map { [$0] }

        let items = Driver.merge(overview, histories, workplaces)

        // MARK: - Coordinator Methods

//        Task {
//            for await _ in input.showAlarmList.values {
//                // coordinator.showNotiList()
//            }
//        }
////
//        Task {
//            for await id in input.showAttendanceDetails.values {
//                // coordinator.
//            }
//        }



        return Output(
            loading: loading,
            items: items,
            isStartRecording: isStartRecording,
            isSaveRecording: .empty()
        )
    }
}
