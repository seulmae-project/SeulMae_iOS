//
//  DefaultWorkScheduleRepository.swift
//  SeulMae
//
//  Created by 조기열 on 9/8/24.
//

import Foundation
import RxSwift

protocol WorkScheduleRepository {
    func fetchWorkScheduleList(workplaceId: Workplace.ID) -> Single<[WorkSchedule]>
}

final class DefaultWorkScheduleRepository: WorkScheduleRepository {
    
    // MARK: - Dependancies
    
    private let network: WorkScheduleNetworking
    
    // MARK: - Life Cycle Methods
    
    init(network: WorkScheduleNetworking) {
        self.network = network
    }
    
    func fetchWorkScheduleList(workplaceId: Workplace.ID) -> RxSwift.Single<[WorkSchedule]> {
        return network.rx
            .request(.fetchWorkScheduleList(workplaceId: workplaceId))
            .do(onSuccess: { response in
                Swift.print("response: \(try response.mapString())")
            }, onError: { error in
                Swift.print("error: \(error)")
            })
            .map(BaseResponseDTO<[WorkScheduleDTO]>.self)
            .map { try $0.toDomain() }
    }
}
