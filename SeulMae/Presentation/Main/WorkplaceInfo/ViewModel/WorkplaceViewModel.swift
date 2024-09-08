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
    private let attendanceUseCase: AttendanceUseCase
    private let workplaceUseCase: WorkplaceUseCase
    private let noticeUseCase: NoticeUseCase
        
    // MARK: - Life Cycle
    
    init(
        dependency: (
            coordinator: MainFlowCoordinator,
            attendanceUseCase: AttendanceUseCase,
            workplaceUseCase: WorkplaceUseCase,
            noticeUseCase: NoticeUseCase
        )
    ) {
        self.coordinator = dependency.coordinator
        self.attendanceUseCase = dependency.attendanceUseCase
        self.workplaceUseCase = dependency.workplaceUseCase
        self.noticeUseCase = dependency.noticeUseCase
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
        //
        let accountID = Driver.just("yonggipo") // 로그인시 or 자동 로그인시의 경우도?
        // current workplace
        let recent = accountID.flatMapLatest { [weak self] accountID -> Driver<MainViewItem> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.workplaceUseCase
                .fetchWorkplaces(accountID: accountID)
                .compactMap { $0.first(where: { $0.id == 8 }) }
                .map { MainViewItem(userWorkplaceID: $0.userWorkplaceId, workplaceID: $0.id, navItemTitle: $0.name, isManager: accountID == "yonggipo") }
                .asDriver()
        }
        
        let managerLogic = recent.filter { $0.isManager }
        let memberLogic = recent.filter { !$0.isManager }
        
        // MARK: Manager Logic
        // 출석일자 조회 일
        // let date
        let attendances = managerLogic.flatMapLatest { [weak self] item -> Driver<[AttendanceListItem]> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.attendanceUseCase
                .fetchAttendanceRequestList(workplaceID: item.workplaceID, date: Date.ext.now)
                .asDriver()
        }
        
        let appNotis = managerLogic.flatMapLatest { [weak self] item -> Driver<[AppNotification]> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.noticeUseCase
                .fetchAppNotificationList(userWorkplaceID: item.workplaceID)
                .asDriver()
        }
        
        
        // MARK: - Member Logic
        
        // MARK: - Common Log
        
        let members = recent.flatMapLatest { [weak self] item -> Driver<[Member]> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.workplaceUseCase
                .fetchMemberList(workplaceIdentifier: item.workplaceID)
                .asDriver()
        }
        
        let announceList = noticeUseCase
            .fetchMainAnnounceList()
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
