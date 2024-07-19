//
//  WorkplaceUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import Foundation
import RxSwift

protocol WorkplaceUseCase {
    func fetchMemberList(_ workplaceID: String) -> RxSwift.Single<[Member]>
    func addWorkplace(_ request: AddWorkplaceRequest) -> Single<Bool>
    func fetchWorkplaceList(_ keyword: String) -> Single<[Workplace]>
    func fetchWorkplaceDetail(_ workplaceID: String) -> Single<Workplace>
    func updateWorkplace(_ request: UpdateWorkplaceRequest) -> Single<Bool>
    func deleteWorkplace(_ workplaceID: String) -> Single<Bool>
    func submitApplication(_ workplaceID: String) -> Single<Bool>    // body
    func acceptApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
    func denyApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
}

final class DefaultWorkplaceUseCase: WorkplaceUseCase {
    
    private let workplaceRepository: WorkplaceRepository
    
    init(workplaceRepository: WorkplaceRepository) {
        self.workplaceRepository = workplaceRepository
    }
    
    func fetchMemberList(_ workplaceID: String) -> RxSwift.Single<[Member]> {
        workplaceRepository.fetchMemberList(workplaceID)
    }
    
    func addWorkplace(_ request: AddWorkplaceRequest) -> RxSwift.Single<Bool> {
        workplaceRepository.addWorkplace(request)
    }
    
    func fetchWorkplaceList(_ keyword: String) -> RxSwift.Single<[Workplace]> {
        workplaceRepository.fetchWorkplaceList(keyword)
    }
    
    func fetchWorkplaceDetail(_ workplaceID: String) -> RxSwift.Single<Workplace> {
        workplaceRepository.fetchWorkplaceDetail(workplaceID)
    }
    
    func updateWorkplace(_ request: UpdateWorkplaceRequest) -> RxSwift.Single<Bool> {
        workplaceRepository.updateWorkplace(request)
    }
    
    func deleteWorkplace(_ workplaceID: String) -> RxSwift.Single<Bool> {
        workplaceRepository.deleteWorkplace(workplaceID)
    }
    
    func submitApplication(_ workplaceID: String) -> RxSwift.Single<Bool> {
        workplaceRepository.submitApplication(workplaceID)
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
