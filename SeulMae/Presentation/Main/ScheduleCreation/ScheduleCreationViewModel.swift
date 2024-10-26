//
//  ScheduleCreationViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 10/25/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ScheduleCreationViewModel: ViewModel {

    struct Input {
        let onLoad: Signal<()>
        let onRefresh: Signal<()>
        let title: Driver<String>
        let startTime: Driver<String>
        let endTime: Driver<String>
        let weekdays: Driver<[Int]>
        let onInvite: Signal<()>
        let members: Driver<[ScheduleCreationItem]>
        let onCreate: Signal<()>
    }

    struct Output {
        let loading: Driver<Bool>
        let items: Driver<[ScheduleCreationItem]>
    }

    // MARK: - Dependencies

    private let coordinator: WorkplaceFlowCoordinator
    private let workScheduleUseCase: WorkScheduleUseCase
    private let workplaceUseCase: WorkplaceUseCase

    init(
        dependency: (
            coordinator: WorkplaceFlowCoordinator,
            workScheduleUseCase: WorkScheduleUseCase,
            workplaceUseCase: WorkplaceUseCase
        )
    ) {
        self.coordinator = dependency.coordinator
        self.workScheduleUseCase = dependency.workScheduleUseCase
        self.workplaceUseCase = dependency.workplaceUseCase
    }

    @MainActor func transform(_ input: Input) -> Output {
        let tracker = ActivityIndicator()
        let loading = tracker.asDriver()
        
        // MARK: - Handle Output
        let onLoad = Signal.merge(input.onLoad, input.onRefresh)
        let members = onLoad.withUnretained(self)
            .flatMapLatest { (self, _) in
                self.workplaceUseCase.fetchCurrentWorkplaceMemberList()
                    .trackActivity(tracker)
                    .map { $0.map(ScheduleCreationItem.init(member:)) }
                    .asDriver()
            }

        let items = Driver.merge(members)

        // MARK: - Handle Input
        let scheduleInfo = Driver.combineLatest(input.title, input.startTime, input.endTime, input.weekdays, input.members) { (title: $0, start: $1, end: $2, weekdays: $3, members: $4) }

//        let _ = input.onCreate.withLatestFrom(scheduleInfo)
//            .withUnretained(self)
//            .flatMapLatest { (self, info) in
//                self.workScheduleUseCase
//                    .addWorkSchedule(request: <#T##AddWorkScheduleRequest#>)
//            }



        return Output(
            loading: loading,
            items: items
        )
    }
}
