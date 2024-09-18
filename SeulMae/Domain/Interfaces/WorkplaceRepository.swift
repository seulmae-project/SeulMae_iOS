//
//  WorkplaceRepository.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import Foundation
import RxSwift

protocol WorkplaceRepository {
//addWorkplace(request: AddNewWorkplaceRequest, data: Data)
//case fetchWorkplaceList
//case fetchWorkplaceDetails(workplaceId: Workplace.ID)
//case updateWorkplace(requset: UpdateWorkplaceRequest)
//case deleteWorkplace(workplaceId: Workplace.ID)
//case submitApplication(workplaceId: Workplace.ID)
//case acceptApplication(workplaceApproveId: String, requset: AcceptApplicationRequset)
//case denyApplication(workplaceApproveId: String)
//case fetchApplicationList(workplaceId: Workplace.ID)
    func fetchMemberList(workplaceId: Workplace.ID) -> Single<[Member]>
//case memberDetails(userId: Member.ID)
//case fetchJoinedWorkplaceList
//case promote(requset: PromoteRequset)
//case leaveWorkplace(workplaceId: Workplace.ID)
    
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
    // func fetchMemberList(workplaceId: Workplace.ID) -> Single<[Member]>
    func fetchMemberInfo(memberId: Member.ID) -> Single<MemberProfile>
}
