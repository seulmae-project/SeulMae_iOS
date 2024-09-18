//
//  NoticeUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import Foundation
import RxSwift

protocol NoticeUseCase {
   
    func fetchAppNotificationList(workplaceId: Workplace.ID) -> Single<[AppNotification]>
}


class DefaultNoticeUseCase: NoticeUseCase {
    
    private let noticeRepository: NoticeRepository
    private let userRepository = UserRepository(network: UserNetworking())
    
    init(noticeRepository: NoticeRepository) {
        self.noticeRepository = noticeRepository
    }
    
    func fetchAppNotificationList(workplaceId: Workplace.ID) -> RxSwift.Single<[AppNotification]> {
        return noticeRepository.fetchAppNotificationList(workplaceId: workplaceId)
    }
}
