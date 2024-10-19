//
//  NotificationUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import Foundation
import RxSwift

protocol NotificationUseCase {
    func fetchAppNotificationList() -> Single<[AppNotification]>
}

class DefaultNotificationUseCase: NotificationUseCase {
    
    private let noticeRepository: NotificationRepository
    private let userRepository = UserRepository(network: UserNetworking())
    
    init(noticeRepository: NotificationRepository) {
        self.noticeRepository = noticeRepository
    }
    
    func fetchAppNotificationList() -> RxSwift.Single<[AppNotification]> {
        let workplaceId = userRepository.currentWorkplaceId
        return noticeRepository.fetchAppNotificationList(workplaceId: workplaceId)
    }
}
