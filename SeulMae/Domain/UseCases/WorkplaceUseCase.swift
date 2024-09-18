//
//  WorkplaceUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import Foundation
import RxSwift

protocol WorkplaceUseCase {
    // Search workplace
    func fetchWorkplaces(keyword: String) -> Single<[Workplace]>
    func fetchWorkplaces(accountID: String) -> Single<[Workplace]>
    func fetchWorkplaces() -> Single<[Workplace]>
    
    // Workpalce details
    func fetchWorkplaceDetail(workplaceID id: Workplace.ID) -> Single<Workplace>
    func submitApplication(workplaceID id: Workplace.ID) -> Single<Bool>

    // Add new workplace
    func addNewWorkplace(request: AddNewWorkplaceRequest) -> Single<Bool>

    
    
    func updateWorkplace(_ request: UpdateWorkplaceRequest) -> Single<Bool>
    func deleteWorkplace(workplaceIdentifier id: Workplace.ID) -> Single<Bool>
    func acceptApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
    func denyApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
    
    
    func fetchMemberList() -> Single<[Member]>
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
    
    func fetchWorkplaces(accountID: String) -> RxSwift.Single<[Workplace]> {
        let dicArray = workplaceRepository.fetchWorkplaces(accountID: accountID)
        return dicArray.map { array in
            return array.map { dic in
                Workplace(
                    id: dic["id"] as! Int,
                    name: dic["name"] as! String,
                    userWorkplaceId: dic["user_workplace_id"] as! Int,
                    isManager: dic["is_manager"] as! Bool,
                    address: Address(mainAddress: "", subAddress: ""),
                    invitationCode: "",
                    contact: "",
                    imageURL: [],
                    thumbnailURL: [],
                    manager: "",
                    mainAddress: "",
                    subAddress: ""
                )
            }
        }
    }
    
    // MARK: - Search
    
    func fetchWorkplaces(keyword: String) -> RxSwift.Single<[Workplace]> {
        workplaceRepository.fetchWorkplaces(keyword: keyword)
    }
    
    // MARK: - Details
    
    func fetchWorkplaceDetail(workplaceID id: Workplace.ID) -> RxSwift.Single<Workplace> {
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
    
    func fetchMemberInfo(
        memberIdentifier id: Member.ID
    ) -> RxSwift.Single<MemberProfile> {
        return workplaceRepository.fetchMemberInfo(memberId: id)
            .do(onError: { error in
                print("error: \(error)")
            })
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
}
