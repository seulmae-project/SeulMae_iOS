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
    struct Input {
        let onLoad: Signal<()>
        let refresh: Signal<()>
        let showNotis: Signal<()>
        let showDetails: Signal<()>
        let onAttendance: Signal<()>
        let add: Signal<AttendRequest>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let item: Driver<UserHomeItem>
        let isAttendance: Driver<Bool>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: HomeFlowCoordinator
    private let workplaceUseCase: WorkplaceUseCase
    private let attendanceUseCase: AttendanceUseCase
    private let attendanceHistoryUseCase: AttendanceHistoryUseCase
    private let attendanceService: AttendanceService
    private var disposeBag = DisposeBag()

    // MARK: - Life Cycle
    
    init(
        dependencies: (
            coordinator: HomeFlowCoordinator,
            workplaceUseCase: WorkplaceUseCase,
            attendanceUseCase: AttendanceUseCase,
            attendanceHistoryUseCase: AttendanceHistoryUseCase,
            attendanceService: AttendanceService
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.workplaceUseCase = dependencies.workplaceUseCase
        self.attendanceUseCase = dependencies.attendanceUseCase
        self.attendanceHistoryUseCase = dependencies.attendanceHistoryUseCase
        self.attendanceService = dependencies.attendanceService
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let tracker = ActivityIndicator()
        let loading = tracker.asDriver()

        let onLoad = Signal.merge(.just(()), input.onLoad, input.refresh)
        
        let item = onLoad.withUnretained(self)
            .flatMapLatest { (self, _) -> Driver<UserHomeItem> in
                self.workplaceUseCase.homeOverView()
                    .trackActivity(tracker)
                    .asDriver()
            }


        let myProfile = onLoad.withUnretained(self)
            .flatMapLatest { (self, _) -> Driver<MemberProfile> in
            return self.workplaceUseCase.fetchMyInfo()
                .trackActivity(tracker)
                .asDriver()
        }

        let isAttendance = input.onAttendance
            .map { AttendanceService.start() }
            .asDriver()



//            .flatMapLatest { profile in
//                let item = strongSelf.workTimeCalculator
//                item.start(workSchedule: profile.workScheduleList.first!)
//                return item.asDriver()
//            }

        let histories = onLoad.flatMapLatest { [weak self] _ -> Driver<[AttendanceHistory]> in
            guard let strongSelf = self else { return .empty() }
            let currentDate = Date()
            let year = Calendar.current.component(.year, from: currentDate)
            let month = Calendar.current.component(.month, from: currentDate)
            return strongSelf.attendanceHistoryUseCase
                .fetchAttendanceCalendar(year: year, month: month)
                .trackActivity(tracker)
                .asDriver()
        }
    
//        let isAttend = input.onAttendance
//            .flatMapLatest { [weak self] request -> Driver<Bool> in
//                guard let strongSelf = self else { return .empty() }
//                return strongSelf.attendanceUseCase
//                    .attend(request: request)
//                    .trackActivity(tracker)
//                    .asDriver()
//            }
//        
        
//        Task {
//            for await _ in isAttend.values {
//                
//            }
//        }
        
        input.onLoad
            .emit(onNext: { _ in
               // self.coordinator.showScheduleReminder()
                
            })
            .disposed(by: disposeBag)
        
        Task {
            for await _ in input.onLoad.values {
              // TODO: viewDidLoad dispose issue
            }
        }
        
    
        
        
        // MARK: - Coordinator
        
        Task {
            for await id in input.showDetails.values {
                // coordinator.
            }
        }
        
        Task {
            for await _ in input.showNotis.values {
                // coordinator.showNotiList()
            }
        }



        return Output(
            loading: loading,
            item: item,
            isAttendance: isAttendance
        )
    }
}
