//
//  ManagerHomeViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 9/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ManagerHomeViewModel {
    
    // MARK: - Internal Types
        
    struct Input {
        let onLoad: Signal<()>
        let onRefresh: Signal<()>
        let showNotis: Signal<()>
        let showDetails: Signal<()>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let workplaceInfo: Driver<Workplace>
        let attendanceInfoList: Driver<[Attendance]>
        let joinApplicationList: Driver<[JoinApplication]>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: HomeFlowCoordinator
    // private let userUseCase: UserUseCase
    private let workplaceUseCase: WorkplaceUseCase
    private let attendnaceUseCase: AttendanceUseCase
        
    // MARK: - Life Cycle
    
    init(
        dependencies: (
            coordinator: HomeFlowCoordinator,
            // userUseCase: UserUseCase,
            workplaceUseCase: WorkplaceUseCase,
            attendnaceUseCase: AttendanceUseCase
        )
    ) {
        self.coordinator = dependencies.coordinator
        // self.userUseCase = dependencies.userUseCase
        self.workplaceUseCase = dependencies.workplaceUseCase
        self.attendnaceUseCase = dependencies.attendnaceUseCase
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

        // fetch attendance list
        let attendance = onLoad
            .withUnretained(self)
            .flatMapLatest { (self, _) -> Driver<[Attendance]> in
            return self.attendnaceUseCase
                .fetchAttendanceRequsetList2(date: Date.ext.now)
                .trackActivity(tracker)
                .asDriver()
        }

        // fetch join application list
        let application = onLoad
            .withUnretained(self)
            .flatMapLatest { (self, _) -> Driver<[JoinApplication]> in
                return self.workplaceUseCase
                    .fetchJoinApplicationList()
                    .trackActivity(tracker)
                    .asDriver()
            }

        Task {
            for await _ in input.showDetails.values {
                
            }
        }

        Task {
            for await _ in input.showNotis.values {
                // coordinator.show
            }
        }

        return Output(
            loading: loading,
            workplaceInfo: workplaceInfo,
            attendanceInfoList: attendance,
            joinApplicationList: application
        )
    }
}
