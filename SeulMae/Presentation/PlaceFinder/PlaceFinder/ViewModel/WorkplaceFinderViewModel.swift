//
//  WorkplaceFinderViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 8/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WorkplaceFinderViewModel: ViewModel {
    struct Input {
        let onLoad: Signal<()>
        let onRefresh: Signal<()>
        let showMenu: Signal<()>
        let showReminders: Signal<()>
        let onReminderTap: Signal<()>
        let onCardTap: Signal<Int>
        let search: Signal<()>
        let create: Signal<()>
    }

    struct Output {
        let loading: Driver<Bool>
        let items: Driver<[WorkplaceFinderItem]>
    }

    // MARK: - Dependencies

    private let coordinator: FinderFlowCoordinator
    private let workplaceUseCase: WorkplaceUseCase
    private let notificationUseCase: NotificationUseCase

    // MARK: - Life Cycle

    init(
        dependencies: (
            coordinator: FinderFlowCoordinator,
            workplaceUseCase: WorkplaceUseCase,
            notificationUseCase: NotificationUseCase
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.workplaceUseCase = dependencies.workplaceUseCase
        self.notificationUseCase = dependencies.notificationUseCase
    }

    @MainActor func transform(_ input: Input) -> Output {
        let tracker = ActivityIndicator()
        let loading = tracker.asDriver()

        let onLoad = Signal.merge(input.onLoad, input.onRefresh)

        let reminders = onLoad.withUnretained(self)
            .flatMapLatest { (self, _) -> Driver<[WorkplaceFinderItem]> in
                return self.notificationUseCase.fetchAppNotificationList()
                    .map(WorkplaceFinderItem.reminder(_:))
                    .map { [$0] }
                    .asDriver()
            }

        let workplaces = onLoad.withUnretained(self)
            .flatMapLatest { (self, _) -> Driver<[WorkplaceFinderItem]> in
                self.workplaceUseCase.fetchJoinedWorkplaceList()
                    .flatMap { workplaces -> Single<[WorkplaceFinderItem]> in
                        Single.zip(workplaces.map { workplace in
                            self.workplaceUseCase.fetchMemberList(workplaceId: workplace.id)
                                .map { WorkplaceFinderItem.workplace(workplace, memberList: $0) }
                        })
                    }
                    .asDriver()
            }

        let submitted = onLoad.withUnretained(self)
            .flatMapLatest { (self, _) -> Driver<[WorkplaceFinderItem]> in
                return self.workplaceUseCase
                    .fetchSubmittedApplications()
                    .map { $0.filter({ !$0.isApprove }) }
                    .flatMap { applications -> Single<[WorkplaceFinderItem]> in
                        Single.zip(applications.map { application in
                            self.workplaceUseCase.fetchWorkplaceDetail(workplaceId: application.workplaceId)
                                .map { WorkplaceFinderItem.application(application, workplace: $0) }
                        })
                    }
                    .asDriver()
            }

        let items = Driver.merge(reminders, workplaces, submitted)

        // MARK: - Coordinator Logic

        Task {
            for await _ in input.showMenu.values {
                coordinator.moveToScheduleCreation()
            }
        }

        Task {
            for await _ in input.showReminders.values {
                coordinator.showReminderList()
            }
        }

        Task {
            for await _ in input.onReminderTap.values {
                coordinator.showReminderList()
            }
        }

        Task {
            for await indexPath in input.onCardTap.values {
                if (indexPath == 0) {
                    coordinator.showSearchWorkPlace()
                } else {
                    coordinator.showAddNewWorkplace()
                }
            }
        }

        Task {
            for await _ in input.search.values {
                coordinator.showSearchWorkPlace()
            }
        }
        
        Task {
            for await _ in input.create.values {
                coordinator.showAddNewWorkplace()
            }
        }
        
        return Output(
            loading: loading,
            items: items
        )
    }
}

