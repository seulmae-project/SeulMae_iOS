//
//  NoticeUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import Foundation
import RxSwift

protocol NoticeUseCase {
    func addNotice(_ request: AddNoticeRequset) -> Single<Bool>
    func updateNotice(noticeIdentifier id: Announce.ID, with request: UpdateNoticeRequest) -> Single<Bool>
    func fetchNoticeDetail(noticeIdentifier id: Announce.ID) -> Single<NoticeDetail>
    func fetchAnnounceList(page: Int, size: Int) -> Single<[Announce]>
    func fetchMustReadNoticeList(workplaceIdentifier id: Workplace.ID) -> Single<[Announce]>
    func fetchMainAnnounceList() -> Single<[Announce]>
    func deleteNotice(noticeIdentifier id: Announce.ID) -> Single<Bool>
    
    
    func fetchAppNotificationList(userWorkplaceID id: Workplace.ID) -> Single<[AppNotification]>
}

class DefaultNoticeUseCase: NoticeUseCase {
    func fetchAppNotificationList(userWorkplaceID id: Workplace.ID) -> RxSwift.Single<[AppNotification]> {
        return noticeRepository.fetchAppNotificationList(userWorkplaceID: id)
    }
    
    class UserRepository {
        var currentWorkplaceId: Workplace.ID {
            return 8
            // return UserDefaults.standard.integer(forKey: "currentWorkplaceId")
        }
    }
    
    private let noticeRepository: NoticeRepository
    private let userRepository = UserRepository()
    
    init(noticeRepository: NoticeRepository) {
        self.noticeRepository = noticeRepository
    }
    
    func addNotice(_ request: AddNoticeRequset) -> Single<Bool> {
        noticeRepository.addNotice(request)
    }
    
    func updateNotice(noticeIdentifier id: Announce.ID, with request: UpdateNoticeRequest) -> Single<Bool> {
        noticeRepository.updateNotice(noticeIdentifier: id, request)
    }
    
    func fetchNoticeDetail(noticeIdentifier id: Announce.ID) -> Single<NoticeDetail> {
        noticeRepository.fetchNoticeDetail(noticeIdentifier: id)
    }
    
    func fetchAnnounceList(page: Int, size: Int) -> Single<[Announce]> {
        let workplaceId = userRepository.currentWorkplaceId
        return noticeRepository.fetchAnnounceList(workplaceId: workplaceId, page: page, size: size)
    }
    
    func fetchMustReadNoticeList(workplaceIdentifier id: Workplace.ID) -> Single<[Announce]> {
        noticeRepository.fetchMustReadNoticeList(workplaceIdentifier: id)
    }
    
    func fetchMainAnnounceList() -> Single<[Announce]> {
        let workplaceId = userRepository.currentWorkplaceId
        return noticeRepository.fetchMainAnnounceList(workplaceId: workplaceId)
    }
    
    func deleteNotice(noticeIdentifier id: Announce.ID) -> Single<Bool> {
        noticeRepository.deleteNotice(noticeIdentifier: id)
    }
}
