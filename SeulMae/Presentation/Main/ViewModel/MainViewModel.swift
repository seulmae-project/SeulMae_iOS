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
        let changeWorkplace: Signal<()>
        
        let showWorkplace: Signal<()>
        let showRemainders: Signal<()>
        
        let attedanceDate: Driver<Date>
        
        let onMemberTap: Signal<Member>
        let onBarButtonTap: Signal<()>
    }
    
    struct Output {
        let item: Driver<MainViewItem>
        let members: Driver<[Member]>
        let attendanceListItems: Driver<[AttendanceListItem]>
        let notices: Driver<[Notice]>
        let appNotis: Driver<[AppNotification]>
    }
    
    // MARK: - Dependencies
    
    private let coordinator: MainFlowCoordinator
    private let attendanceUseCase: AttendanceUseCase
    private let workplaceUseCase: WorkplaceUseCase
    private let noticeUseCase: NoticeUseCase
    
    // TODO: workplace 변경시 변경되어야 함 userInfo?
    // private var workplaceID: Workplace.ID
    // private var isManager: Bool
    
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
        let account = UserDefaults.standard.string(forKey: "account")
        Swift.print("🥹 account: \(account!)")
        // let colums = WorkplaceTable.fetch(account: account!)
//        Swift.print("🥹 table colums: \(colums)")
//        self.workplaceID = (colums.first!["id"] as? Int)!
        // self.isManager = (account == "yonggipo") // 후 로직 처리
    }
    
    
    // 메인에 들어온 거면 유저 로그인을 거침
    // + 메인에 보여줄 근무지 정보도 있음
    
    // 유저의 근무지 정보를 받아옴 > 리스트까지는 필요없을 것 같음..
    
    // 공통 fetchCommonData
    // 근무지 타이틀
    // 유저 리스트
    // 공지 리스트
    
    // 가장 작은
    // workplaceUseCase
    // 권한 별 데이타
    // fetch    
    
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
        
        let notices = recent.flatMapLatest { [weak self] item -> Driver<[Notice]> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.noticeUseCase
                .fetchMainNoticeList(workplaceIdentifier: item.workplaceID)
                .asDriver()
        }
        
        
       
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
            for await _ in input.changeWorkplace.values {
                coordinator.showWorkplaceList()
            }
        }
        
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
            item: recent,
            members: members,
            attendanceListItems: attendances,
            notices: notices,
            appNotis: appNotis
        )
    }
}
