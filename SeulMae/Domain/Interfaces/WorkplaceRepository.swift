//
//  WorkplaceRepository.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import Foundation
import RxSwift

protocol WorkplaceRepository {
    func addWorkplace(_ request: AddWorkplaceRequest) -> Single<Bool>
    func fetchWorkplaceList(_ keyword: String) -> Single<[Workplace]>
    func fetchWorkplaceDetail(workplaceIdentifier id: Workplace.ID) -> Single<Workplace>
    func updateWorkplace(_ request: UpdateWorkplaceRequest) -> Single<Bool>
    func deleteWorkplace(workplaceIdentifier id: Workplace.ID) -> Single<Bool>
    func submitApplication(workplaceIdentifier id: Workplace.ID) -> Single<Bool>    // body
    func acceptApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
    func denyApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
    func fetchMemberList(workplaceIdentifier id: Workplace.ID) -> Single<[Member]>
    func fetchMemberInfo(memberIdentifier id: Member.ID) -> Single<MemberInfo>
}
