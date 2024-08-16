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
    
    // Workpalce details
    func fetchWorkplaceDetail(workplaceID id: Workplace.ID) -> Single<Workplace>
    func submitApplication(workplaceID id: Workplace.ID) -> Single<Bool>

    // Add new workplace
    func addNewWorkplace(request: AddNewWorkplaceRequest) -> Single<Bool>

    
    
    func fetchMemberList(workplaceIdentifier id: Workplace.ID) -> RxSwift.Single<[Member]>
    
    func updateWorkplace(_ request: UpdateWorkplaceRequest) -> Single<Bool>
    func deleteWorkplace(workplaceIdentifier id: Workplace.ID) -> Single<Bool>
    func acceptApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
    func denyApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
    func fetchMemberInfo(memberIdentifier id: Member.ID) -> RxSwift.Single<MemberInfo>
}

final class DefaultWorkplaceUseCase: WorkplaceUseCase {
    
    private let workplaceRepository: WorkplaceRepository
    
    init(workplaceRepository: WorkplaceRepository) {
        self.workplaceRepository = workplaceRepository
    }
    
    // MARK: - Search
    
    func fetchWorkplaces(keyword: String) -> RxSwift.Single<[Workplace]> {
        workplaceRepository.fetchWorkplaces(keyword: keyword)
    }
    
    // MARK: - Details
    
    func fetchWorkplaceDetail(workplaceID id: Workplace.ID) -> RxSwift.Single<Workplace> {
        workplaceRepository.fetchWorkplaceDetail(workplaceID: id)
    }

    func submitApplication(workplaceID id: Workplace.ID) -> RxSwift.Single<Bool> {
        workplaceRepository.submitApplication(workplaceID: id)
    }
    
    // MARK: - Add New
    
    func addNewWorkplace(request: AddNewWorkplaceRequest) -> RxSwift.Single<Bool> {
        workplaceRepository.addNewWorkplace(request: request)
    }
    
    

    
    
    
    
    
    func fetchMemberList(workplaceIdentifier id: Workplace.ID) -> RxSwift.Single<[Member]> {
        workplaceRepository.fetchMemberList(workplaceIdentifier: id)
    }
    
    func fetchMemberInfo(
        memberIdentifier id: Member.ID
    ) -> RxSwift.Single<MemberInfo> {
        return workplaceRepository.fetchMemberInfo(memberIdentifier: id)
            .do(onError: { error in
                print("error: \(error)")
            })
    }
    
    func updateWorkplace(_ request: UpdateWorkplaceRequest) -> RxSwift.Single<Bool> {
        workplaceRepository.updateWorkplace(request)
    }
    
    func deleteWorkplace(workplaceIdentifier id: Workplace.ID) -> RxSwift.Single<Bool> {
        workplaceRepository.deleteWorkplace(workplaceIdentifier: id)
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
