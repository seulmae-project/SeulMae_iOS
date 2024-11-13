//
//  WorkplaceRepository.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import Foundation
import RxSwift

protocol WorkplaceRepository {
    // MARK: - Local DB
    func read(accountId: String) -> [Workplace]
    func read(workplaceId: Workplace.ID) -> Workplace
    func create(workplaceList: [Workplace], accountId: String) -> Bool
    
    
//addWorkplace(request: AddNewWorkplaceRequest, data: Data)
    func fetchWorkplaceList(keyword: String) -> Single<[Workplace]>
//case fetchWorkplaceDetails(workplaceId: Workplace.ID)
//case updateWorkplace(requset: UpdateWorkplaceRequest)
//case deleteWorkplace(workplaceId: Workplace.ID)
    func submitApplication(workplaceId: Workplace.ID) -> Single<Bool>
    func acceptApplication(workplaceApproveId: Int, initialUserInfo: InitialUserInfo) -> Single<Bool>
    func denyApplication(workplaceApproveId: Int) -> Single<Bool>
    func fetchMemberList(workplaceId: Workplace.ID) -> Single<[Member]>
    func fetchJoinApplicationList(workplaceId: Workplace.ID) -> Single<[JoinApplication]>
//case memberDetails(userId: Member.ID)
    func fetchJoinedWorkplaceList() -> Single<[Workplace]>
//case promote(requset: PromoteRequset)
//case leaveWorkplace(workplaceId: Workplace.ID)
    func fetchSubmittedApplications() -> Single<[SubmittedApplication]>
  
    
    
    func addNewWorkplace(request: AddNewWorkplaceRequest) -> Single<Bool>
    func fetchWorkplaceDetail(workplaceId: Workplace.ID) -> Single<Workplace>
    func updateWorkplace(_ request: UpdateWorkplaceRequest) -> Single<Bool>
    func deleteWorkplace(workplaceId: Workplace.ID) -> Single<Bool>
    // func fetchMemberList(workplaceId: Workplace.ID) -> Single<[Member]>
    
    
    func fetchMemberInfo(memberId: Member.ID) -> Single<MemberProfile>
    func fetchMyInfo(workplaceId: Workplace.ID) -> Single<MemberProfile>

    
}
