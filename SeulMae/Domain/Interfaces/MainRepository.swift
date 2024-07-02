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
    func submitApplication(_ workplaceID: String) -> Single<Bool>    // body
    func acceptApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
    func denyApplication(workplaceApproveId: String, workplaceJoinHistoryId: String) -> Single<Bool>
    
    /// - Tag: Common
    func addNotice(_ request: AddNoticeRequset) -> Single<Bool>
    func updateNotice(noticeID: String, _ request: UpdateNoticeRequest) -> Single<Bool>
    func fetchNoticeDetail(noticeID: String) -> Single<NoticeDetail>
    func fetchAllNotice(workplaceID: String, page: Int, size: Int) -> Single<[Notice]>
    func fetchMustReadNoticeList(workplaceID: Int) -> Single<[Notice]>
    func fetchMainNoticeList(workplaceID: Int) -> Single<[Notice]>
    func deleteNotice(noticeID: Int) -> Single<Bool>
}
