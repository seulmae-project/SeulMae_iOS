//
//  NotificationUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import Foundation
import RxSwift

protocol NotificationUseCase {
    func fetchAppNotificationList() -> Single<[Reminder]>
}

class DefaultNotificationUseCase: NotificationUseCase {
    
    private let noticeRepository: NotificationRepository
    private let userRepository = UserRepository(network: UserNetworking())
    
    init(noticeRepository: NotificationRepository) {
        self.noticeRepository = noticeRepository
    }
    
    func fetchAppNotificationList() -> RxSwift.Single<[Reminder]> {
        let workplaceId = userRepository.currentWorkplaceId
        return noticeRepository.fetchAppNotificationList(workplaceId: workplaceId)
    }
}
