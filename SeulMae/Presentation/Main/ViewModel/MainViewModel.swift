//
//  MainViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 6/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel: ViewModel {
    
    struct Input {
        let showWorkplace: Signal<()>
        let changeWorkplace: Signal<()>
        let showRemainders: Signal<()>
        
        let attedanceDate: Driver<Date>
        
        let onMemberTap: Signal<Member>
        let onBarButtonTap: Signal<()>
    }
    
    struct Output {
        let members: Driver<[Member]>
        let attendanceListItems: Driver<[AttendanceListItem]>
        let notices: Driver<[Notice]>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: MainFlowCoordinator
    private let attendanceUseCase: AttendanceUseCase
    private let workplaceUseCase: WorkplaceUseCase
    private let noticeUseCase: NoticeUseCase
    
    // TODO: workplace 변경시 변경되어야 함 userInfo?
    private var workplaceID: Workplace.ID
    private var isManager: Bool
    
    
//
//    private let validationService: ValidationService
//
//    private let wireframe: Wireframe
        
    // MARK: - Life Cycle
    
    init(
        dependency: (
            coordinator: MainFlowCoordinator,
            attendanceUseCase: AttendanceUseCase,
            workplaceUseCase: WorkplaceUseCase,
            noticeUseCase: NoticeUseCase
//            validationService: ValidationService,
//            wireframe: Wireframe
        )
    ) {
        self.coordinator = dependency.coordinator
        self.attendanceUseCase = dependency.attendanceUseCase
        self.workplaceUseCase = dependency.workplaceUseCase
        self.noticeUseCase = dependency.noticeUseCase
        let a = WorkplaceTable.get2()
        Swift.print("🥹 table colums: \(a)")
        let dic = a.first
        let id = Int(dic!["id"] as! String)!
        self.workplaceID = id
        self.isManager = true
        Swift.print("🥹 workplaceID: \(workplaceID)")
        Swift.print("🥹 isManager: \(isManager)")
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
        
        let attendanceDate = input.attedanceDate
            .startWith(Date.ext.now)
            .filter { _ in self.isManager }
        
        let attendances = attendanceDate.flatMapLatest { [weak self] date -> Driver<[AttendanceListItem]> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.attendanceUseCase
                .fetchAttendanceRequestList(workplaceID: strongSelf.workplaceID, date: date)
                .map { $0.map(AttendanceListItem.init) }
                .asDriver()
        }
        
        let members = workplaceUseCase.fetchMemberList(workplaceIdentifier: workplaceID)
            .asDriver()
        
        let notices = noticeUseCase.fetchMainNoticeList(workplaceIdentifier: workplaceID)
            .asDriver()
       
        // MARK: Code Verification
        
//        let validatedCode = input.code
//            .map { $0.count == 6 }
//        let codeVerificationEnabled = Driver.combineLatest(
//            validatedCode, loading) { code, loading in
//                code &&
//                !loading
//            }
//            .distinctUntilChanged()
//        
//        let verifiedCode = input.verifyCode.withLatestFrom(input.code)
//            .flatMapLatest { [weak self] code -> Driver<Bool> in
//                guard let strongSelf = self else { return .empty() }
//                return strongSelf.authUseCase
//                    .codeVerification(code)
//                    .trackActivity(indicator)
//                    .asDriver(onErrorJustReturn: false)
//            }
//            .startWith(false)
//        
        // MARK: Flow Logic
        
        Task {
            for await member in input.onMemberTap.values {
                coordinator.showMemberInfo(member: member)
            }
        }
        
        Task {
            for await _ in input.onBarButtonTap.values {
                coordinator.showNotiList(workplaceIdentifier: 0)
            }
        }
        
        
//        let nextStepEnabled = Driver.combineLatest(
//            validatedSMS, verifiedCode, loading) { validated, verified, loading in
//                validated &&
//                verified &&
//                !loading
//            }
//            .distinctUntilChanged()
//        
        return Output(
            members: members,
            attendanceListItems: attendances,
            notices: notices
        )
    }
}
