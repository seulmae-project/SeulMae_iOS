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
        let onCheck: Signal<(isCheck: Bool, memberId: Member.ID)>
        let onCreate: Signal<()>
    }

    struct Output {
        let loading: Driver<Bool>
        let items: Driver<ScheduleCreationViewController.Item>
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

        return Output(
            loading: .empty(),
            items: .empty()
        )
    }
}
