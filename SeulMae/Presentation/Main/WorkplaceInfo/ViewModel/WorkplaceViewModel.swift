//
//  WorkplaceViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 9/8/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WorkplaceViewModel: ViewModel {
    struct Input {
        let showMemberDetails: Signal<Member>
        let showAnnouceList: Signal<()>
        let showAnnouceDetails: Signal<Announce.ID>
        let showWorkScheduleList: Signal<()>
        let showWorkScheduleDetails: Signal<WorkSchedule.ID>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let listItems: Driver<[WorkplaceListItem]>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: WorkplaceFlowCoordinator
    private let memberUseCase: MemberUseCase
    private let announceUseCase: AnnounceUseCase
    private let workScheduleUseCase: WorkScheduleUseCase
        
    // MARK: - Life Cycle
    
    init(
        dependencies: (
            coordinator: WorkplaceFlowCoordinator,
            memberUseCase: MemberUseCase,
            announceUseCase: AnnounceUseCase,
            workScheduleUseCase: WorkScheduleUseCase
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.memberUseCase = dependencies.memberUseCase
        self.announceUseCase = dependencies.announceUseCase
        self.workScheduleUseCase = dependencies.workScheduleUseCase
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
        
//        let members = memberUseCase
//            .fetchMemberList()
//            .map { $0.map(WorkplaceListItem.init(member:)) }
//            .asDriver()
        
        let announceList = announceUseCase
            .fetchMainAnnounceList()
            .map { $0.map(WorkplaceListItem.init(announce:)) }
            .asDriver()
        
        let workScheduleList = workScheduleUseCase
            .fetchWorkScheduleList()
            .map { $0.map(WorkplaceListItem.init(workSchedule:)) }
            .asDriver()
        
        Task {
            for await announce in announceList.values {
                 Swift.print("announce: \(announce)")
            }
        }
        
        Task {
            for await schedule in workScheduleList.values {
                // Swift.print("schedule: \(schedule)")
            }
        }
        
        // let listItems = Driver.merge(members, announceList, workScheduleList)
        let listItems = Driver.merge( announceList, workScheduleList)
        // MARK: Coordinator Logic
        
        Task {
            for await member in input.showMemberDetails.values {
                // coordinator.showMemberInfo(member: member)
            }
        }
        
        Task {
            for await _ in input.showAnnouceList.values {
                coordinator.showAnnounceList()
            }
        }
        
        Task {
            for await announceId in input.showAnnouceDetails.values {
                coordinator.showAnnounceDetails(announceId: announceId)
            }
        }
        
        Task {
            for await _ in input.showWorkScheduleList.values {
                coordinator.showWorkScheduleList()
            }
        }
        
        Task {
            for await workScheduleId in input.showWorkScheduleDetails.values {
                coordinator.showWorkScheduleDetails(workScheduleId: workScheduleId)
            }
        }
        
        return Output(
            loading: loading,
            listItems: listItems
        )
    }
}
