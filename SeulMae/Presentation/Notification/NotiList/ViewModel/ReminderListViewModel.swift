//
//  NotiListViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 7/22/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ReminderListViewModel: ViewModel {
    struct Input {
        let onLoad: Signal<()>
        let onRefresh: Signal<()>
        let onItemTap: Signal<ReminderListItem>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let items: Driver<[ReminderListItem]>
    }
    
    // MARK: - Dependency
    
    private let coordinator: CommonFlowCoordinator
    private let noticeUseCase: NotificationUseCase
        
    // MARK: - Life Cycle
    
    init(
        dependency: (
            coordinator: CommonFlowCoordinator,
            noticeUseCase: NotificationUseCase
        )
    ) {
        self.coordinator = dependency.coordinator
        self.noticeUseCase = dependency.noticeUseCase
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
        
        let onLoad = Signal.merge(.just(()), input.onLoad, input.onRefresh)

        let fetched = onLoad.withUnretained(self)
            .flatMapLatest { (self, _) -> Driver<[ReminderListItem]> in
                self.noticeUseCase
                    .fetchAppNotificationList()
                    .map { $0.map(ReminderListItem.reminder(_:)) }
                    .asDriver()
            }

        let filtered = input.onItemTap
            .filter { $0.section == .category }
            .asDriver()
            .withLatestFrom(fetched) { (category: $0, items: $1) }
            .map { pair in
                if (pair.category.category == "전체") {
                    return pair.items
                } else {
                    return pair.items.filter { $0.reminder!.type.category == pair.category.category! }
                }
            }

        let items = Driver.merge(fetched, filtered)

        // MARK: Coordinator Logic
        
        Task {
            for await item in input.onItemTap.values {
                if case .category = item.section,
                   let category = item.category {
                    Swift.print("Did tap noti category: \(category)")
                }
                
                if case .list = item.section,
                   let notiId = item.reminder?.id {
                    Swift.print("Did tap noti: \(notiId)")
                }
            }
        }

        return Output(
            loading: loading,
            items: items
        )
    }
}
