//
//  WorkplaceUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import Foundation
import RxSwift

protocol WorkplaceUseCase {
   
    func fetchWorkplaces(keyword: String) -> Single<[Workplace]>
    func addNewWorkplace(request: AddWorkplaceRequest) -> Single<Bool>

    
    
    func fetchMemberList(workplaceIdentifier id: Workplace.ID) -> RxSwift.Single<[Member]>
    
    func fetchWorkplaceDetail(workplaceIdentifier id: Workplace.ID) -> Single<Workplace>
    func updateWorkplace(_ request: UpdateWorkplaceRequest) -> Single<Bool>
    func deleteWorkplace(workplaceIdentifier id: Workplace.ID) -> Single<Bool>
    func submitApplication(workplaceIdentifier id: Workplace.ID) -> Single<Bool>    // body
    func acceptApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
    func denyApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
    func fetchMemberInfo(memberIdentifier id: Member.ID) -> RxSwift.Single<MemberInfo>
}

final class DefaultWorkplaceUseCase: WorkplaceUseCase {
    
    private let workplaceRepository: WorkplaceRepository
    
    init(workplaceRepository: WorkplaceRepository) {
        self.workplaceRepository = workplaceRepository
    }
    
    func fetchWorkplaces(keyword: String) -> RxSwift.Single<[Workplace]> {
        workplaceRepository.fetchWorkplaces(keyword: keyword)
    }
    
    func addNewWorkplace(request: AddWorkplaceRequest) -> RxSwift.Single<Bool> {
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
    
   
    
    func fetchWorkplaceDetail(workplaceIdentifier id: Workplace.ID) -> RxSwift.Single<Workplace> {
        workplaceRepository.fetchWorkplaceDetail(workplaceIdentifier: id)
    }
    
    func updateWorkplace(_ request: UpdateWorkplaceRequest) -> RxSwift.Single<Bool> {
        workplaceRepository.updateWorkplace(request)
    }
    
    func deleteWorkplace(workplaceIdentifier id: Workplace.ID) -> RxSwift.Single<Bool> {
        workplaceRepository.deleteWorkplace(workplaceIdentifier: id)
    }
    
    func submitApplication(workplaceIdentifier id: Workplace.ID) -> RxSwift.Single<Bool> {
        workplaceRepository.submitApplication(workplaceIdentifier: id)
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
