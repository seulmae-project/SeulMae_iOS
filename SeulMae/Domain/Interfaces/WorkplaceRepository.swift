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
    func fetchWorkplaceList(keyword: String) -> Single<[Workplace]>
//case fetchWorkplaceDetails(workplaceId: Workplace.ID)
//case updateWorkplace(requset: UpdateWorkplaceRequest)
//case deleteWorkplace(workplaceId: Workplace.ID)
    func submitApplication(workplaceId: Workplace.ID) -> Single<Bool>
//case acceptApplication(workplaceApproveId: String, requset: AcceptApplicationRequset)
//case denyApplication(workplaceApproveId: String)
//case fetchApplicationList(workplaceId: Workplace.ID)
    func fetchMemberList(workplaceId: Workplace.ID) -> Single<[Member]>
//case memberDetails(userId: Member.ID)
    func fetchJoinedWorkplaceList() -> Single<[Workplace]>
//case promote(requset: PromoteRequset)
//case leaveWorkplace(workplaceId: Workplace.ID)
    
    func read(accountId: String) -> [Workplace]
    func create(workplaceList: [Workplace], accountId: String) -> Bool
    
    
    func addNewWorkplace(request: AddNewWorkplaceRequest) -> Single<Bool>
    func fetchWorkplaceDetail(workplaceId: Workplace.ID) -> Single<Workplace>
    func updateWorkplace(_ request: UpdateWorkplaceRequest) -> Single<Bool>
    func deleteWorkplace(workplaceId: Workplace.ID) -> Single<Bool>
    func acceptApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
    func denyApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
    // func fetchMemberList(workplaceId: Workplace.ID) -> Single<[Member]>
    
    
    func fetchMemberInfo(memberId: Member.ID) -> Single<MemberProfile>
    func fetchMyInfo(workplaceId: Workplace.ID) -> Single<MemberProfile>
    
    
}
