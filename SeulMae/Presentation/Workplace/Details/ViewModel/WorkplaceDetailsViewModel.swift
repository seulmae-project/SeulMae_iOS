//
//  WorkplaceDetailsViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 8/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WorkplaceDetailsViewModel: ViewModel {
    struct Input {
        let onLoad: Signal<()>
        let onRefresh: Signal<()>
        let onSubmit: Signal<()>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let item: Driver<WorkplaceDetailsItem>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: TabBarFlowCoordinator
    private let workplaceUseCase: WorkplaceUseCase
    private let wireframe: Wireframe
    private let workplaceId: Workplace.ID
    
    // MARK: - Life Cycle

    init(
        dependencies: (
            coordinator: TabBarFlowCoordinator,
            workplaceUseCase: WorkplaceUseCase,
            wireframe: Wireframe,
            workplaceId: Workplace.ID
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.workplaceUseCase = dependencies.workplaceUseCase
        self.wireframe = dependencies.wireframe
        self.workplaceId = dependencies.workplaceId
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let tracker = ActivityIndicator()
        let loading = tracker.asDriver()
        
        let onLoad = Signal.merge(.just(()), input.onLoad, input.onRefresh)
        
        let item = onLoad.flatMapLatest { [weak self] _ -> Driver<WorkplaceDetailsItem> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.workplaceUseCase
                .fetchWorkplaceDetail(workplaceId: strongSelf.workplaceId)
                .trackActivity(tracker)
                .map(WorkplaceDetailsItem.init(workplace:))
                .asDriver()
        }
        
        let isSubmit = input.onSubmit
            .flatMapLatest { [weak self] _ -> Driver<Bool> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.workplaceUseCase
                    .submitApplication(workplaceID: strongSelf.workplaceId)
                    .trackActivity(tracker)
                    .flatMap { isSubmit in
                        let message = isSubmit ? "가입 요청되었습니다" : "잠시 후 다시 시도해주세요"
                        return strongSelf.wireframe
                            .promptFor(message, cancelAction: "확인", actions: [])
                            .map { _ in isSubmit }
                    }
                    .asDriver()
            }
        
        Task {
            for await isSubmit in isSubmit.values {
                if isSubmit {
                    coordinator.goBack()
                } else {
                    // TODO: - Handle API Error...
                }
            }
        }
        
        // MARK: Output
        
        return Output(
            loading: loading,
            item: item
        )
    }
}
