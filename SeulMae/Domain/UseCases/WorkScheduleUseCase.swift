//
//  WorkScheduleUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 9/8/24.
//

import Foundation
import RxSwift

protocol WorkScheduleUseCase {
    func addWorkSchedule(request: AddWorkScheduleRequest) -> Single<Bool>
    
    func fetchWorkScheduleDetails(workScheduleId: WorkSchedule.ID) -> Single<WorkSchedule>
    func updateWorkSchedule(workScheduleId: WorkSchedule.ID, request: AddWorkScheduleRequest) -> Single<Bool>
    //    func deleteWorkSchedule(workScheduleId: WorkSchedule.ID) -> Single<Bool>
    func fetchWorkScheduleList() -> Single<[WorkSchedule]>
//    func addUserToWorkSchedule(workScheduleId: WorkSchedule.ID, memberId: Member.ID) -> Single<Bool>
//    func moveUserToWorkSchedule(fromWorkScheduleId: WorkSchedule.ID, toWorkScheduleId: WorkSchedule.ID) -> Single<Bool>
//    func fetchUserList(workScheduleId: WorkSchedule.ID) -> Single<[User]>
//    func deleteUserFromWorkSchedule(workScheduleId: WorkSchedule.ID) -> Single<Bool>
}

class DefaultWorkScheduleUseCase: WorkScheduleUseCase {
    private let workScheduleRepository: WorkScheduleRepository
    private let userRepository = UserRepository(network: UserNetworking())
    
    init(workScheduleRepository: WorkScheduleRepository) {
        self.workScheduleRepository = workScheduleRepository
    }
    
    func addWorkSchedule(request: AddWorkScheduleRequest) -> RxSwift.Single<Bool> {
        return workScheduleRepository.addWorkSchedule(request: request)
    }
    
    func fetchWorkScheduleDetails(workScheduleId: WorkSchedule.ID) -> RxSwift.Single<WorkSchedule> {
        return workScheduleRepository.fetchWorkScheduleDetails(workScheduleId: workScheduleId)
    }
    
    func updateWorkSchedule(workScheduleId: WorkSchedule.ID, request: AddWorkScheduleRequest) -> RxSwift.Single<Bool> {
        return workScheduleRepository.updateWorkSchedule(workScheduleId: workScheduleId, request: request)
    }
    
    func fetchWorkScheduleList() -> RxSwift.Single<[WorkSchedule]> {
        let curretnWorkplaceId = userRepository.currentWorkplaceId
        return workScheduleRepository.fetchWorkScheduleList(workplaceId: curretnWorkplaceId)
    }
}
