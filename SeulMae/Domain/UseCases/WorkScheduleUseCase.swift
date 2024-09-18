//
//  WorkScheduleUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 9/8/24.
//

import Foundation
import RxSwift

protocol WorkScheduleUseCase {
    // func fetchAnnounceList(page: Int, size: Int) -> Single<[Announce]>
    func fetchWorkScheduleList() -> Single<[WorkSchedule]>
}

class DefaultWorkScheduleUseCase: WorkScheduleUseCase {
   
    private let workScheduleRepository: WorkScheduleRepository
    private let userRepository = UserRepository(network: UserNetworking())
    
    init(workScheduleRepository: WorkScheduleRepository) {
        self.workScheduleRepository = workScheduleRepository
    }
    
    func fetchWorkScheduleList() -> RxSwift.Single<[WorkSchedule]> {
        let curretnWorkplaceId = userRepository.currentWorkplaceId
        return workScheduleRepository.fetchWorkScheduleList(workplaceId: curretnWorkplaceId)
    }
    
}
