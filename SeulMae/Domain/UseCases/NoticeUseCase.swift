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
    func updateNotice(noticeID: String, _ request: UpdateNoticeRequest) -> Single<Bool>
    func fetchNoticeDetail(noticeID: String) -> Single<NoticeDetail>
    func fetchAllNotice(workplaceID: String, page: Int, size: Int) -> Single<[Notice]>
    func fetchMustReadNoticeList(workplaceID: Int) -> Single<[Notice]>
    func fetchMainNoticeList(workplaceID: Int) -> Single<[Notice]>
    func deleteNotice(noticeID: Int) -> Single<Bool>
}

class DefaultNoticeUseCase: NoticeUseCase {
    
    private let noticeRepository: NoticeRepository
    
    init(noticeRepository: NoticeRepository) {
        self.noticeRepository = noticeRepository
    }
    
    func addNotice(_ request: AddNoticeRequset) -> Single<Bool> {
        noticeRepository.addNotice(request)
    }
    
    func updateNotice(
        noticeID: String,
        _ request: UpdateNoticeRequest
    ) -> Single<Bool> {
        noticeRepository.updateNotice(
            noticeID: noticeID,
            request
        )
    }
    
    func fetchNoticeDetail(noticeID: String) -> Single<NoticeDetail> {
        noticeRepository.fetchNoticeDetail(noticeID: noticeID)
    }
    
    func fetchAllNotice(
        workplaceID: String,
        page: Int,
        size: Int
    ) -> Single<[Notice]> {
        noticeRepository.fetchAllNotice(
            workplaceID: workplaceID,
            page: page,
            size: size
        )
    }
    
    func fetchMustReadNoticeList(workplaceID: Int) -> Single<[Notice]> {
        noticeRepository.fetchMustReadNoticeList(workplaceID: workplaceID)
    }
    
    func fetchMainNoticeList(workplaceID: Int) -> Single<[Notice]> {
        noticeRepository.fetchMainNoticeList(workplaceID: workplaceID)
    }
    
    func deleteNotice(noticeID: Int) -> Single<Bool> {
        noticeRepository.deleteNotice(noticeID: noticeID)
    }
}
