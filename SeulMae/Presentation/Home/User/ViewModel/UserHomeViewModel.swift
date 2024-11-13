//
//  UserHomeViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 9/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class UserHomeViewModel: ViewModel {
    
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
        
        // Fetch workplace details
        let workplace = onLoad.withUnretained(self)
            .flatMapLatest { (self, _) -> Driver<Workplace> in
                return self.workplaceUseCase
                    .fetchMyWorkplaceDetail()
                    .trackActivity(tracker)
                    .asDriver()
            }
        
        // Fetch joined workplace list
        let workplaces = onLoad.withUnretained(self)
            .flatMapLatest { (self, _) -> Driver<[UserHomeItem]> in
                return self.workplaceUseCase
                    .fetchJoinedWorkplaceList()
                    .trackActivity(tracker)
                    .map { $0.map(UserHomeItem.init(workplace:)) }
                    .asDriver(onErrorJustReturn: [])
            }

        // Convert to collection view item
        let overview = Driver.combineLatest(myProfile, workplace) {
            (profile: $0, workplace: $1) }
            .map(UserHomeItem.init(profile:workplace:))
            .map { [$0] }

        // Start recording the time for attendance
        let isStartRecording = input.onStartRecording
            .withUnretained(self)
            .map { (self, _) in self.attendanceUseCase.attend() }
            .asDriver()

        // Save record with fetched wage
        let wage = myProfile.map(\.baseWage)
        let isEndRecording = input.onSaveRecording.withLatestFrom(wage)
            .withUnretained(self)
            .flatMapLatest { (self, wage) in
                return self.attendanceUseCase.leaveWork(wage: wage)
                    .asDriver()
            }

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

//        / input.showAlarmList.emit(with: self, onNext: { (self,
        //                // coordinator.showNotiList()

        return Output(
            loading: loading,
            items: items,
            isStartRecording: isStartRecording,
            isSaveRecording: isEndRecording
        )
    }
}
