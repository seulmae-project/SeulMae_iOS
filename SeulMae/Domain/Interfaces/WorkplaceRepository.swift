//
//  WorkplaceRepository.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import Foundation
import RxSwift

protocol WorkplaceRepository {
    func fetchWorkplaces(keyword: String) -> Single<[Workplace]>
    func addNewWorkplace(request: AddNewWorkplaceRequest) -> Single<Bool>
    
    
    
    func fetchWorkplaceDetail(workplaceID id: Workplace.ID) -> Single<Workplace>
    func updateWorkplace(_ request: UpdateWorkplaceRequest) -> Single<Bool>
    func deleteWorkplace(workplaceIdentifier id: Workplace.ID) -> Single<Bool>
    func submitApplication(workplaceID id: Workplace.ID) -> Single<Bool>    // body
    func acceptApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
    func denyApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
    func fetchMemberList(workplaceIdentifier id: Workplace.ID) -> Single<[Member]>
    func fetchMemberInfo(memberIdentifier id: Member.ID) -> Single<MemberInfo>
}
