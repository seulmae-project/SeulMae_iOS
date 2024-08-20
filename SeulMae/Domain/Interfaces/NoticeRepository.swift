//
//  NoticeRepository.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import Foundation
import RxSwift

protocol NoticeRepository {
    func fetchAppNotificationList(workplaceID id: Workplace.ID) -> Single<[AppNotification]>
    
    func fetchMainNoticeList(workplaceID id: Workplace.ID) -> Single<[Notice]>

    
    func addNotice(_ request: AddNoticeRequset) -> Single<Bool>
    func updateNotice(noticeIdentifier id: Notice.ID, _ request: UpdateNoticeRequest) -> Single<Bool>
    func fetchNoticeDetail(noticeIdentifier id: Notice.ID) -> Single<NoticeDetail>
    func fetchAllNotice(workplaceIdentifier id: Workplace.ID, page: Int, size: Int) -> Single<[Notice]>
    func fetchMustReadNoticeList(workplaceIdentifier id: Workplace.ID) -> Single<[Notice]>
    func deleteNotice(noticeIdentifier id: Notice.ID) -> Single<Bool>
}
