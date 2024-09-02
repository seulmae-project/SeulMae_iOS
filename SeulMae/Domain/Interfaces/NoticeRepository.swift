//
//  NoticeRepository.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import Foundation
import RxSwift

protocol NoticeRepository {
    func fetchAppNotificationList(userWorkplaceID id: Workplace.ID) -> Single<[AppNotification]>
    
    
    // Announce
    func fetchMainAnnounceList(workplaceId id: Workplace.ID) -> Single<[Announce]>
    func fetchAnnounceList(workplaceId id: Workplace.ID, page: Int, size: Int) -> Single<[Announce]>

    
    func addNotice(_ request: AddNoticeRequset) -> Single<Bool>
    func updateNotice(noticeIdentifier id: Announce.ID, _ request: UpdateNoticeRequest) -> Single<Bool>
    func fetchNoticeDetail(noticeIdentifier id: Announce.ID) -> Single<NoticeDetail>
    func fetchMustReadNoticeList(workplaceIdentifier id: Workplace.ID) -> Single<[Announce]>
    func deleteNotice(noticeIdentifier id: Announce.ID) -> Single<Bool>
}
