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
    private let wireframe: Wireframe

    init(
        dependencies: (
            coordinator: WorkplaceFlowCoordinator,
            workScheduleUseCase: WorkScheduleUseCase,
            workplaceUseCase: WorkplaceUseCase,
            wireframe: Wireframe
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.workScheduleUseCase = dependencies.workScheduleUseCase
        self.workplaceUseCase = dependencies.workplaceUseCase
        self.wireframe = dependencies.wireframe
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
        let scheduleInfo = Driver.combineLatest(input.title, input.startTime, input.endTime, input.weekdays, resultSelector: WorkScheduleInfo.init)
        let selectedMembers = input.members
            .map { $0.map(\ScheduleCreationItem.member.id) }
        let pair = Driver.combineLatest(scheduleInfo, selectedMembers) { (info: $0, members: $1) }

        let isCreate = input.onCreate.withLatestFrom(pair)
            .withUnretained(self)
            .flatMapLatest { (self, pair) -> Driver<Bool> in
                self.workScheduleUseCase
                    .create(scheduleInfo: pair.info, members: pair.members)
                    .trackActivity(tracker)
                    .flatMapLatest { isCreated -> Observable<Bool> in
                        let title = isCreated ? "일정 생성 완료" : "일정 생성 실패"
                        let message = isCreated ? "일정을 생성하였습니다" : "잠시 뒤 다시 시도해주세요"
                        return self.wireframe
                            .promptAlert(title, message: message, actions: ["확인"])
                            .map { _ in isCreated }
                    }
                    .asDriver(onErrorJustReturn: false)
            }

        Task {
            for await isCreate in isCreate.values {
                Swift.print(#fileID, "isCreate: \(isCreate)")
                coordinator.goBack()
            }
        }

        return Output(
            loading: loading,
            items: items
        )
    }
}
