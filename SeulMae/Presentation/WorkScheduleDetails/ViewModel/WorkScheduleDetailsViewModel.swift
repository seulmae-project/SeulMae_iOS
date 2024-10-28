//
//  WorkScheduleDetailsViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 9/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WorkScheduleDetailsViewModel: ViewModel {
    
    // MARK: - Internal Types
    
    struct Input {
        let name: Driver<String>
        let startTime: Driver<Date>
        let endTime: Driver<Date>
        let weekdays: Driver<[Int]>
        let members: Driver<[Member.ID]>
        let save: Signal<()>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let title: Driver<String>
        let items: Driver<[WorkScheduleDetailsItem]>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: WorkplaceFlowCoordinator
    private let workScheduleUseCase: WorkScheduleUseCase
    private let workScheduleId: WorkSchedule.ID?
        
    // MARK: - Life Cycle
    
    init(
        dependencies: (
            coordinator: WorkplaceFlowCoordinator,
            workScheduleUseCase: WorkScheduleUseCase,
            workScheduleId: WorkSchedule.ID?
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.workScheduleUseCase = dependencies.workScheduleUseCase
        self.workScheduleId = dependencies.workScheduleId
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
        
        // initial data
        let items: Driver<[WorkScheduleDetailsItem]>
        let title: Driver<String>
        if let workScheduleId {
            let details = workScheduleUseCase.fetchWorkScheduleDetails(workScheduleId: workScheduleId)
                .trackActivity(indicator)
                .asDriver()
            items = details.map { self.toItems(from: $0) }
            title = details.map(\.title)
        } else {
            items = .empty()
            title = .just("새로운 근무일정")
        }
        
        // combine inputs
        let times = Driver.combineLatest(input.startTime, input.endTime) {
            (start: $0, end: $1) }
        
        let request = Driver.combineLatest(
            input.name, times, input.weekdays) { (name, times, weekdays) -> WorkSchedule in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                let startTiem = dateFormatter.string(from: times.start)
                let endTiem = dateFormatter.string(from: times.end)
                Swift.print("testtset")
//                return WorkSchedule(
//                    workScheduleTitle: name, startTime: startTiem, endTime: endTiem, days: weekdays)
                return WorkSchedule(id: 0, title: "", days: [], startTime: "", endTime: "", isActive: false)
        }
        
        // update or add new work schedule
        let isSaved = input.save.withLatestFrom(request)
            .flatMapLatest { [weak self] request -> Driver<Bool> in
                guard let strongSelf = self else { return .empty() }
                if let workScheduleId = strongSelf.workScheduleId {
//                    return strongSelf.workScheduleUseCase
//                        .updateWorkSchedule(
//                            workScheduleId: workScheduleId, request: request)
                    return .empty()
                        .trackActivity(indicator)
                        .asDriver()
                } else {
//                    return strongSelf.workScheduleUseCase
//                        .create(request: request)
                    return .empty()
                        .trackActivity(indicator)
                        .asDriver()
                }
            }
        
        Task {
            for await isSaved in isSaved.values {
                Swift.print("isSaved: \(isSaved)")
            }
        }
        
        return Output(
            loading: loading,
            title: title,
            items: items
        )
    }
    
    func toItems(from schedule: WorkSchedule) -> [WorkScheduleDetailsItem] {
        return [
            .init(name: schedule.title),
            .init(startTime: schedule.startTime),
            .init(endTime: schedule.endTime),
            .init(weekdays: schedule.days),
            // .init(members: workSchedule.)
        ]
    }
}
