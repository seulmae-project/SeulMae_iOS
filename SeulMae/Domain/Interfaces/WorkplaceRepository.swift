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
    func fetchWorkplaces(accountID: String) -> Single<Array<[String: Any]>>
    func saveWorkplaces(_ workplaces: [Workplace], withAccount account: String) -> Single<Bool>
    
    
    func addNewWorkplace(request: AddNewWorkplaceRequest) -> Single<Bool>
    func fetchWorkplaceDetail(workplaceId: Workplace.ID) -> Single<Workplace>
    func updateWorkplace(_ request: UpdateWorkplaceRequest) -> Single<Bool>
    func deleteWorkplace(workplaceId: Workplace.ID) -> Single<Bool>
    func submitApplication(workplaceId: Workplace.ID) -> Single<Bool>    // body
    func acceptApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
    func denyApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
    func fetchMemberList(workplaceId: Workplace.ID) -> Single<[Member]>
    func fetchMemberInfo(memberId: Member.ID) -> Single<MemberProfile>
}
