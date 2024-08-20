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
    func updateNotice(noticeIdentifier id: Notice.ID, with request: UpdateNoticeRequest) -> Single<Bool>
    func fetchNoticeDetail(noticeIdentifier id: Notice.ID) -> Single<NoticeDetail>
    func fetchAllNotice(workplaceIdentifier id: Workplace.ID, page: Int, size: Int) -> Single<[Notice]>
    func fetchMustReadNoticeList(workplaceIdentifier id: Workplace.ID) -> Single<[Notice]>
    func fetchMainNoticeList(workplaceIdentifier id: Workplace.ID) -> Single<[Notice]>
    func deleteNotice(noticeIdentifier id: Notice.ID) -> Single<Bool>
    
    
    func fetchNotificationList(workplaceID id: Workplace.ID) -> Single<[AppNotification]>
}

class DefaultNoticeUseCase: NoticeUseCase {
    func fetchNotificationList(workplaceID id: Workplace.ID) -> RxSwift.Single<[AppNotification]> {
        .just([])
    }
    
    
    private let noticeRepository: NoticeRepository
    
    init(noticeRepository: NoticeRepository) {
        self.noticeRepository = noticeRepository
    }
    
    func addNotice(_ request: AddNoticeRequset) -> Single<Bool> {
        noticeRepository.addNotice(request)
    }
    
    func updateNotice(noticeIdentifier id: Notice.ID, with request: UpdateNoticeRequest) -> Single<Bool> {
        noticeRepository.updateNotice(noticeIdentifier: id, request)
    }
    
    func fetchNoticeDetail(noticeIdentifier id: Notice.ID) -> Single<NoticeDetail> {
        noticeRepository.fetchNoticeDetail(noticeIdentifier: id)
    }
    
    func fetchAllNotice(
        workplaceIdentifier id: Workplace.ID,
        page: Int,
        size: Int
    ) -> Single<[Notice]> {
        noticeRepository.fetchAllNotice(
            workplaceIdentifier: id,
            page: page,
            size: size
        )
    }
    
    func fetchMustReadNoticeList(workplaceIdentifier id: Workplace.ID) -> Single<[Notice]> {
        noticeRepository.fetchMustReadNoticeList(workplaceIdentifier: id)
    }
    
    func fetchMainNoticeList(workplaceIdentifier id: Workplace.ID) -> Single<[Notice]> {
        noticeRepository.fetchMainNoticeList(workplaceID: id)
    }
    
    func deleteNotice(noticeIdentifier id: Notice.ID) -> Single<Bool> {
        noticeRepository.deleteNotice(noticeIdentifier: id)
    }
}
