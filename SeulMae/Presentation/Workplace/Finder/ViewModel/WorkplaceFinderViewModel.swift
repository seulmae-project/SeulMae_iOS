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
        let search: Signal<()>
        let create: Signal<()>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let items: Driver<[WorkplaceFinderItem]>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: TabBarFlowCoordinator
    private let workplaceUseCase: WorkplaceUseCase
    
    // MARK: - Life Cycle
    
    init(
        dependencies: (
            coordinator: TabBarFlowCoordinator,
            workplaceUseCase: WorkplaceUseCase
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.workplaceUseCase = dependencies.workplaceUseCase
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let tracker = ActivityIndicator()
        let loading = tracker.asDriver()
        
        let onLoad = Signal.merge(.just(()), input.onLoad, input.onRefresh)
        
        let submitted = onLoad
            .withUnretained(self)
            .flatMapLatest { (self, _) -> Driver<[WorkplaceFinderItem]> in
               return self.workplaceUseCase
                    .fetchSubmittedApplications()
                    .flatMap { applications -> Single<[WorkplaceFinderItem]> in
                        Single.zip(applications.map { application in
                            self.workplaceUseCase.fetchWorkplaceDetail(workplaceId: application.workplaceId)
                                .map { WorkplaceFinderItem.application(application, workplace: $0) }
                        })
                    }
                    .asDriver()
            }

        let workplaces = onLoad
            .withUnretained(self)
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

        let items = Driver.merge(workplaces, submitted)

        // MARK: - Coordinator Logic

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

