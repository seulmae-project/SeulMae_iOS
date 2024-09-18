//
//  DefaultWorkScheduleRepository.swift
//  SeulMae
//
//  Created by 조기열 on 9/8/24.
//

import Foundation
import RxSwift

protocol WorkScheduleRepository {
    func addWorkSchedule(request: AddWorkScheduleRequest) -> Single<Bool>
    func fetchWorkScheduleDetails(workScheduleId: WorkSchedule.ID) -> Single<WorkSchedule>
    func updateWorkSchedule(workScheduleId: WorkSchedule.ID, request: AddWorkScheduleRequest) -> Single<Bool>
    func deleteWorkSchedule(workScheduleId: WorkSchedule.ID) -> Single<Bool>
    func fetchWorkScheduleList(workplaceId: Workplace.ID) -> Single<[WorkSchedule]>
    func addUserToWorkSchedule(workScheduleId: WorkSchedule.ID, memberId: Member.ID) -> Single<Bool>
    func moveUserToWorkSchedule(fromWorkScheduleId: WorkSchedule.ID, toWorkScheduleId: WorkSchedule.ID) -> Single<Bool>
    func fetchUserList(workScheduleId: WorkSchedule.ID) -> Single<[User]>
    func deleteUserFromWorkSchedule(workScheduleId: WorkSchedule.ID) -> Single<Bool>
}

final class DefaultWorkScheduleRepository: WorkScheduleRepository {
    
    // MARK: - Dependancies
    
    private let network: WorkScheduleNetworking
    
    // MARK: - Life Cycle Methods
    
    init(network: WorkScheduleNetworking) {
        self.network = network
    }
    
    func addWorkSchedule(request: AddWorkScheduleRequest) -> RxSwift.Single<Bool> {
        return network.rx
            .request(.addWorkSchedule(request: request))
            .map(BaseResponseDTO<Bool>.self)
            .map { $0.isSuccess }
    }
    
    func fetchWorkScheduleDetails(workScheduleId: WorkSchedule.ID) -> RxSwift.Single<WorkSchedule> {
        return network.rx
            .request(.fetchWorkScheduleDetails(workScheduleId: workScheduleId))
            .map(BaseResponseDTO<WorkScheduleDTO>.self)
            .map { $0.toDomain()! }
    }
    
    func updateWorkSchedule(
        workScheduleId: WorkSchedule.ID,
        request: AddWorkScheduleRequest) -> RxSwift.Single<Bool> {
        return network.rx
            .request(.updateWorkSchedule(workScheduleId: workScheduleId, requset: request))
            .map(BaseResponseDTO<Bool>.self)
            .map { $0.isSuccess }
    }
    
    func deleteWorkSchedule(workScheduleId: WorkSchedule.ID) -> RxSwift.Single<Bool> {
        return network.rx
            .request(.deleteWorkSchedule(workScheduleId: workScheduleId))
            .map(BaseResponseDTO<Bool>.self)
            .map { $0.isSuccess }
    }
    
    func fetchWorkScheduleList(workplaceId: Workplace.ID) -> RxSwift.Single<[WorkSchedule]> {
        return network.rx
            .request(.fetchWorkScheduleList(workplaceId: workplaceId))
            .map(BaseResponseDTO<[WorkScheduleDTO]>.self)
            .map { $0.toDomain() }
    }
    
    func addUserToWorkSchedule(workScheduleId: WorkSchedule.ID, memberId: Member.ID) -> RxSwift.Single<Bool> {
        return network.rx
            .request(.addUserToWorkSchedule(workScheduleId: workScheduleId, memberId: memberId))
            .map(BaseResponseDTO<Bool>.self)
            .map { $0.isSuccess }
    }
    
    func moveUserToWorkSchedule(fromWorkScheduleId: WorkSchedule.ID, toWorkScheduleId: WorkSchedule.ID) -> RxSwift.Single<Bool> {
        return network.rx
            .request(.moveUserToWorkSchedule(fromWorkScheduleId: fromWorkScheduleId, toWorkScheduleId: toWorkScheduleId))
            .map(BaseResponseDTO<Bool>.self)
            .map { $0.isSuccess }
    }
    
    func fetchUserList(workScheduleId: WorkSchedule.ID) -> RxSwift.Single<[User]> {
        return network.rx
            .request(.fetchUserList(workScheduleId: workScheduleId))
            .map(BaseResponseDTO<[UserDTO]>.self)
            .map { $0.toDomain() }
    }
    
    func deleteUserFromWorkSchedule(
        workScheduleId: WorkSchedule.ID) -> RxSwift.Single<Bool> {
        return network.rx
            .request(.deleteUserFromWorkSchedule(workScheduleId: workScheduleId))
            .map(BaseResponseDTO<Bool>.self)
            .map { $0.isSuccess }
    }
}
