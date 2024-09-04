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
    func addAnnounce(request: AddAnnounceRequset) -> Single<Bool>
    func updateAnnounce(announceId id: Announce.ID, request: UpdateAnnounceRequest) -> Single<Bool>

    
 
    func fetchAnnounceDetail(announceId id: Announce.ID) -> Single<AnnounceDetail>
    func fetchMustReadNoticeList(workplaceIdentifier id: Workplace.ID) -> Single<[Announce]>
    func deleteNotice(noticeIdentifier id: Announce.ID) -> Single<Bool>
}
