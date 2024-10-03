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
    func acceptApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
    func denyApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
    
    func fetchMemberList() -> Single<[Member]>
    
    func fetchMemberInfo(memberId: Member.ID) -> Single<MemberProfile>
    func fetchMyInfo() -> Single<MemberProfile>
    func fetchJoinedWorkplaceList() -> Single<[Workplace]>

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
        workplaceApproveId: String,
        workplaceJoinHistoryId: String
    ) -> RxSwift.Single<Bool> {
        workplaceRepository.acceptApplication(
            workplaceApproveId: workplaceApproveId,
            workplaceJoinHistoryId: workplaceJoinHistoryId
        )
    }
    
    func denyApplication(
        workplaceApproveId: String,
        workplaceJoinHistoryId: String
    ) -> RxSwift.Single<Bool> {
        workplaceRepository.denyApplication(
            workplaceApproveId: workplaceApproveId,
            workplaceJoinHistoryId: workplaceJoinHistoryId
        )
    }
    
    func fetchMemberInfo(memberId id: Member.ID) -> RxSwift.Single<MemberProfile> {
        return workplaceRepository.fetchMemberInfo(memberId: id)
            .do(onError: { error in
                print("error: \(error)")
            })
    }
    
    func fetchMyInfo() -> RxSwift.Single<MemberProfile> {
        let workplaceId = userRepository.currentWorkplaceId
        return workplaceRepository.fetchMyInfo(workplaceId: workplaceId)
    }
    
    func fetchJoinedWorkplaceList() -> Single<[Workplace]> {
        return workplaceRepository.fetchJoinedWorkplaceList()
    }
}
