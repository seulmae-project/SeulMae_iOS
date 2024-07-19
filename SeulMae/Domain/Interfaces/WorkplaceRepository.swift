//
//  WorkplaceRepository.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import Foundation
import RxSwift

protocol WorkplaceRepository {
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
