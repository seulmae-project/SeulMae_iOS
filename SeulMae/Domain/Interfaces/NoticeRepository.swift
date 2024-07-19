//
//  NoticeRepository.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import Foundation
import RxSwift

protocol NoticeRepository {
    func addNotice(_ request: AddNoticeRequset) -> Single<Bool>
    func updateNotice(noticeID: String, _ request: UpdateNoticeRequest) -> Single<Bool>
    func fetchNoticeDetail(noticeID: String) -> Single<NoticeDetail>
    func fetchAllNotice(workplaceID: String, page: Int, size: Int) -> Single<[Notice]>
    func fetchMustReadNoticeList(workplaceID: Int) -> Single<[Notice]>
    func fetchMainNoticeList(workplaceID: Int) -> Single<[Notice]>
    func deleteNotice(noticeID: Int) -> Single<Bool>
}
