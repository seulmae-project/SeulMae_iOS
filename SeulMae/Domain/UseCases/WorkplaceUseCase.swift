//
//  WorkplaceUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import Foundation
import RxSwift

protocol WorkplaceUseCase {
    // Local DB
    func readWorkplaceList() -> [Workplace]
    func readDefaultWorkplace() -> Workplace
    
    
    // Search workplace
    func fetchWorkplaces(keyword: String) -> Single<[Workplace]>
    func fetchWorkplaces() -> Single<[Workplace]>
    
   
    
    // Workpalce details
    func fetchWorkplaceDetail(workplaceId id: Workplace.ID) -> Single<Workplace>
    func submitApplication(workplaceID id: Workplace.ID) -> Single<Bool>

    // Add new workplace
    func addNewWorkplace(request: AddNewWorkplaceRequest) -> Single<Bool>

    func updateWorkplace(_ request: UpdateWorkplaceRequest) -> Single<Bool>
    func deleteWorkplace(workplaceIdentifier id: Workplace.ID) -> Single<Bool>
    
    func acceptApplication(workplaceApproveId: Int, initialUserInfo: InitialUserInfo) -> Single<Bool>
    func denyApplication(workplaceApproveId: Int) -> Single<Bool>
    
    func fetchMemberList() -> Single<[Member]>
    
    func fetchMemberInfo(memberId: Member.ID) -> Single<MemberProfile>
    func fetchMyInfo() -> Single<MemberProfile>
    func fetchJoinedWorkplaceList() -> Single<[Workplace]>
    
    func homeOverView() -> Observable<UserHomeItem>
}

final class DefaultWorkplaceUseCase: WorkplaceUseCase {
    func fetchWorkplaces() -> RxSwift.Single<[Workplace]> {
        return .just([])
    }
    
    private let workplaceRepository: WorkplaceRepository
    private let userRepository = UserRepository(network: UserNetworking())
    
    init(workplaceRepository: WorkplaceRepository) {
        self.workplaceRepository = workplaceRepository
    }
    
    // MARK: - Local DB
    
    func readDefaultWorkplace() -> Workplace {
        let defaultWorkplaceId = userRepository.readDefaultWorkplaceId()
        Swift.print("[Workplace Repo]: defaultWorkplaceId: \(defaultWorkplaceId)")
        return workplaceRepository.read(workplaceId: defaultWorkplaceId)
    }
    
    func readWorkplaceList() -> [Workplace] {
        guard let accountId = UserDefaults.standard.string(forKey: "accountId") else {
            return []
        }
        return workplaceRepository.read(accountId: accountId)
    }
    
    // MARK: - Search
    
    func fetchWorkplaces(keyword: String) -> RxSwift.Single<[Workplace]> {
        workplaceRepository.fetchWorkplaceList(keyword: keyword)
    }
    
    // MARK: - Details
    
    func fetchWorkplaceDetail(workplaceId id: Workplace.ID) -> RxSwift.Single<Workplace> {
        workplaceRepository.fetchWorkplaceDetail(workplaceId: id)
    }

    func submitApplication(workplaceID id: Workplace.ID) -> RxSwift.Single<Bool> {
        workplaceRepository.submitApplication(workplaceId: id)
    }
    
    // MARK: - Add New
    
    func addNewWorkplace(request: AddNewWorkplaceRequest) -> RxSwift.Single<Bool> {
        workplaceRepository.addNewWorkplace(request: request)
    }
    
    func fetchMemberList() -> RxSwift.Single<[Member]> {
        let currentWorkplaceId = userRepository.currentWorkplaceId
        return workplaceRepository.fetchMemberList(workplaceId: currentWorkplaceId)
    }
    
    
    func updateWorkplace(_ request: UpdateWorkplaceRequest) -> RxSwift.Single<Bool> {
        workplaceRepository.updateWorkplace(request)
    }
    
    func deleteWorkplace(workplaceIdentifier id: Workplace.ID) -> RxSwift.Single<Bool> {
        workplaceRepository.deleteWorkplace(workplaceId: id)
    }
    
    func acceptApplication(
        workplaceApproveId: Int,
        initialUserInfo: InitialUserInfo
    ) -> RxSwift.Single<Bool> {
        return workplaceRepository.acceptApplication(
            workplaceApproveId: workplaceApproveId,
            initialUserInfo: initialUserInfo
        )
    }
    
    func denyApplication(
        workplaceApproveId: Int) -> RxSwift.Single<Bool> {
        return workplaceRepository.denyApplication(workplaceApproveId: workplaceApproveId)
    }
    
    func fetchMemberInfo(memberId id: Member.ID) -> RxSwift.Single<MemberProfile> {
        return workplaceRepository.fetchMemberInfo(memberId: id)
            .do(onError: { error in
                print("error: \(error)")
            })
    }

    func homeOverView() -> Observable<UserHomeItem> {
        let workplaceId = userRepository.currentWorkplaceId
        let myInfo = workplaceRepository.fetchMyInfo(workplaceId: workplaceId)
            .asObservable()
        let workplaceInfo = workplaceRepository.fetchWorkplaceDetail(workplaceId: workplaceId)
            .asObservable()
        return .combineLatest(myInfo, workplaceInfo) {
            UserHomeItem(workplace: $1, profile: $0)
        }
    }

    func fetchMyInfo() -> RxSwift.Single<MemberProfile> {
        let workplaceId = userRepository.currentWorkplaceId
        return workplaceRepository.fetchMyInfo(workplaceId: workplaceId)
    }
    
    func fetchJoinedWorkplaceList() -> Single<[Workplace]> {
        return workplaceRepository.fetchJoinedWorkplaceList()
    }

    // MARK: - Left Time Progress

    func getProgress(from workStartTime: String) -> Double {
        guard let targetDate = getStartDate(from: workStartTime) else { return 0 }
        let progress = getProgress(targetDate: targetDate)
        Swift.print("남은 시간 진행률: \(progress)")
        return progress
    }

    private func getStartDate(from startTime: String) -> Date? {
        let now = Date.ext.now
        let calendar = Calendar.current
        let midnight = calendar.startOfDay(for: now)
        let timeComponents = startTime.split(separator: ":").map { Int($0) }
        var components = calendar.dateComponents([.year, .month, .day], from: midnight)
        guard let hour = timeComponents[0],
              let minute = timeComponents[1],
              let second = timeComponents[2] else { return nil }
        components.hour = hour
        components.minute = minute
        components.second = second
        return calendar.date(from: components)
    }

    private func getProgress(targetDate: Date) -> Double {
        let now = Date.ext.now
        if now >= targetDate { return 1.0 }

        let timeInterval = targetDate.timeIntervalSince(now)
        let oneDay: TimeInterval = 24 * 60 * 60
        let progress = max(0, min(1, 1 - (timeInterval / oneDay)))
        return progress
    }
}
