//
//  NoticeRepository.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import Foundation
import RxSwift

protocol NoticeRepository {
    func fetchAppNotificationList(workplaceId: Workplace.ID) -> Single<[AppNotification]>
}
