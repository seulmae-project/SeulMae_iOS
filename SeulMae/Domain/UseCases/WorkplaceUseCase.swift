//
//  WorkplaceUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import Foundation
import RxSwift

protocol WorkplaceUseCase {
    func fetchMemberList(workplaceIdentifier id: Workplace.ID) -> RxSwift.Single<[Member]>
    func addWorkplace(_ request: AddWorkplaceRequest) -> Single<Bool>
    func fetchWorkplaceList(_ keyword: String) -> Single<[Workplace]>
    func fetchWorkplaceDetail(workplaceIdentifier id: Workplace.ID) -> Single<Workplace>
    func updateWorkplace(_ request: UpdateWorkplaceRequest) -> Single<Bool>
    func deleteWorkplace(workplaceIdentifier id: Workplace.ID) -> Single<Bool>
    func submitApplication(workplaceIdentifier id: Workplace.ID) -> Single<Bool>    // body
    func acceptApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
    func denyApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
}

final class DefaultWorkplaceUseCase: WorkplaceUseCase {
    
    private let workplaceRepository: WorkplaceRepository
    
    init(workplaceRepository: WorkplaceRepository) {
        self.workplaceRepository = workplaceRepository
    }
    
    func fetchMemberList(workplaceIdentifier id: Workplace.ID) -> RxSwift.Single<[Member]> {
        workplaceRepository.fetchMemberList(workplaceIdentifier: id)
    }
    
    func addWorkplace(_ request: AddWorkplaceRequest) -> RxSwift.Single<Bool> {
        workplaceRepository.addWorkplace(request)
    }
    
    func fetchWorkplaceList(_ keyword: String) -> RxSwift.Single<[Workplace]> {
        workplaceRepository.fetchWorkplaceList(keyword)
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
