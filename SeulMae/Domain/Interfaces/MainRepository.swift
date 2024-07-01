//
//  MainRepository.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import Foundation
import RxSwift

protocol MainRepository {
    /// - Tag: Main
    func fetchMemberList(_ workplaceID: String) -> Single<[Member]>
    
    /// - Tag: Workplace
    func addWorkplace(_ request: AddWorkplaceRequest) -> Single<Bool>
    func fetchWorkplaceList(_ keyword: String) -> Single<[Workplace]>
    func fetchWorkplaceDetail(_ workplaceID: String) -> Single<Workplace>
    func updateWorkplace(_ request: UpdateWorkplaceRequest) -> Single<Bool>
    func deleteWorkplace(_ workplaceID: String) -> Single<Bool>
    func submitApplication(_workplaceID: String) -> Single<Bool>    // body
    func acceptApplication(workplaceApproveId: String, workplaceJoinHistoryId: String)
    func denyApplication(workplaceApproveId: String, workplaceJoinHistoryId: String)
    
    /// - Tag: Common
   
}
