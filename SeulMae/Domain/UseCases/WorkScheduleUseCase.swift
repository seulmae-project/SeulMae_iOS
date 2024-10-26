//
//  WorkScheduleUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 9/8/24.
//

import Foundation
import RxSwift

protocol WorkScheduleUseCase {
    func create(scheduleInfo: WorkScheduleInfo, members: [Member.ID]) -> Single<Bool>

    func fetchWorkScheduleDetails(workScheduleId: WorkSchedule.ID) -> Single<WorkSchedule>
    func updateWorkSchedule(schedule: WorkSchedule) -> RxSwift.Single<Bool>
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
    
    func create(scheduleInfo: WorkScheduleInfo, members: [Member.ID]) -> Single<Bool> {
        let schedule = workScheduleRepository.createWorkSchedule(scheduleInfo: scheduleInfo)
        members.forEach { memberId in
            // TODO: 유저 추가 에러 핸들링?
            _ = workScheduleRepository.addUserToWorkSchedule(
                workScheduleId: 0,// schedule.id,
                memberId: memberId)
        }
        return .just(true)
    }
    
    func fetchWorkScheduleDetails(workScheduleId: WorkSchedule.ID) -> RxSwift.Single<WorkSchedule> {
        return workScheduleRepository.fetchWorkScheduleDetails(workScheduleId: workScheduleId)
    }
    
    func updateWorkSchedule(schedule: WorkSchedule) -> RxSwift.Single<Bool> {
        return workScheduleRepository.updateWorkSchedule(schedule: schedule)
    }
    
    func fetchWorkScheduleList() -> RxSwift.Single<[WorkSchedule]> {
        let curretnWorkplaceId = userRepository.currentWorkplaceId
        return workScheduleRepository.fetchWorkScheduleList(workplaceId: curretnWorkplaceId)
    }
}
