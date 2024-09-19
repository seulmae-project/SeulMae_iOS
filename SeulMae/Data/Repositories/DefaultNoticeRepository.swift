//
//  DefaultNoticeRepository.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import Moya
import RxMoya
import RxSwift

class DefaultNoticeRepository: NotificationRepository {
   
    // MARK: - Dependancies
    
    private let network: NotificationNetworking
    
    // MARK: - Life Cycle Methods
    
    init(network: NotificationNetworking) {
        self.network = network
    }
    
    func fetchAppNotificationList(workplaceId: Workplace.ID) -> RxSwift.Single<[AppNotification]> {
        return network.rx
            .request(.fetchNotifications(workplaceId: workplaceId))
            .map(BaseResponseDTO<[AppNotificationDTO]>.self, using: AppNotificationDTO.decoder)
            .map { try $0.toDomain() }
    }
}
