//
//  AnnounceUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 9/8/24.
//

import Foundation
import RxSwift

protocol AnnounceUseCase {
    func fetchAnnounceList(page: Int, size: Int) -> Single<[Announce]>
    func fetchAnnounceDetail(announceId id: Announce.ID) -> Single<AnnounceDetail>
    func addAnnounce(request: AddAnnounceRequset) -> Single<Bool>
    func updateAnnounce(announceId id: Announce.ID, withRequest request: UpdateAnnounceRequest) -> Single<Bool>
    func saveAnnounce(announceId id: Announce.ID?, title: String, content: String, isImportant: Bool) -> Single<Bool>
    
    func fetchMustReadNoticeList(workplaceIdentifier id: Workplace.ID) -> Single<[Announce]>
    func fetchMainAnnounceList() -> Single<[Announce]>
    func deleteNotice(noticeIdentifier id: Announce.ID) -> Single<Bool>
}

class DefaultAnnounceUseCase: AnnounceUseCase {
    
    private let noticeRepository: NoticeRepository
    private let userRepository = UserRepository(network: UserNetwork())
    
    init(noticeRepository: NoticeRepository) {
        self.noticeRepository = noticeRepository
    }
    
    func fetchAnnounceList(page: Int, size: Int) -> Single<[Announce]> {
        let workplaceId = userRepository.currentWorkplaceId
        return noticeRepository.fetchAnnounceList(workplaceId: workplaceId, page: page, size: size)
    }
    
    func fetchAnnounceDetail(announceId id: Announce.ID) -> Single<AnnounceDetail> {
        noticeRepository.fetchAnnounceDetail(announceId: id)
    }
    
    func addAnnounce(request: AddAnnounceRequset) -> Single<Bool> {
        noticeRepository.addAnnounce(request: request)
    }
    
    func updateAnnounce(announceId id: Announce.ID, withRequest request: UpdateAnnounceRequest) -> Single<Bool> {
        noticeRepository.updateAnnounce(announceId: id, request: request)
    }
    
    func saveAnnounce(announceId id: Announce.ID?, title: String, content: String, isImportant: Bool) -> Single<Bool> {
        if let id {
            let request = UpdateAnnounceRequest(title: title, content: content, isImportant: isImportant)
            return self.updateAnnounce(announceId: id, withRequest: request)
        } else {
            let workplaceId = userRepository.currentWorkplaceId
            let request = AddAnnounceRequset(workplaceId: workplaceId, title: title, content: content, isImportant: isImportant)
            return self.addAnnounce(request: request)
        }
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
