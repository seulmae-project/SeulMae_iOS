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
        let listItems: Driver<WorkplaceListItem>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: MainFlowCoordinator
    private let memberUseCase: MemberUseCase
    private let announceUseCase: AnnounceUseCase
    private let workScheduleUseCase: WorkScheduleUseCase
        
    // MARK: - Life Cycle
    
    init(
        dependencies: (
            coordinator: MainFlowCoordinator,
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
        
        let members = memberUseCase
            .fetchMemberList()
            .asDriver()
        
        let announceList = announceUseCase
            .fetchMainAnnounceList()
            .asDriver()
        
        let workScheduleList = workScheduleUseCase
            .fetchWorkScheduleList()
            .asDriver()
        
        // MARK: Coordinator Logic
        
        Task {
            for await _ in input.showMemberDetails.values {
            
            }
        }
        
        Task {
            for await _ in input.showAnnouceList.values {

            }
        }
        
        Task {
            for await announceId in input.showAnnouceDetails.values {
                
            }
        }
        
        Task {
            for await _ in input.showWorkScheduleList.values {
                
            }
        }
        
        Task {
            for await workScheduleId in input.showWorkScheduleDetails.values {
                
            }
        }
        
        return Output(
            listItems: .empty()
        )
    }
}
