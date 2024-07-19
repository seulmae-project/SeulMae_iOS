//
//  DefaultWorkplaceRepo.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import Foundation
import RxSwift

final class DefaultWorkplaceRepository: WorkplaceRepository {
    func fetchMemberList(workplaceIdentifier id: Workplace.ID) -> RxSwift.Single<[Member]> {
        return Single<BaseResponseDTO<[MemberDTO]>>.create { observer in
            observer(.success(MockData.WorkplaceAPI.memberListSuccess))
            return Disposables.create()
        }
        .map { try $0.toDomain() }
        .do(onError: { error in
            print("error: \(error)")
        })
    }

    func addWorkplace(_ request: AddWorkplaceRequest) -> RxSwift.Single<Bool> {
        Swift.print(#fileID, #function, "\n- request: \(request)\n")
        return Single<BaseResponseDTO<Bool>>.create { observer in
            observer(.success(MockData.WorkplaceAPI.addSuccess))
            return Disposables.create()
        }
        .map { $0.isSuccess }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    func fetchWorkplaceList(_ keyword: String) -> RxSwift.Single<[Workplace]> {
        Swift.print(#fileID, #function, "\n- keyword: \(keyword)\n")
        return Single<BaseResponseDTO<[WorkplaceDTO]>>.create { observer in
            observer(.success(MockData.WorkplaceAPI.workplacesSuccess))
            return Disposables.create()
        }
        .map { try $0.toDomain() }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    func fetchWorkplaceDetail(workplaceIdentifier id: Workplace.ID) -> RxSwift.Single<Workplace> {
        Swift.print(#fileID, #function, "\n- workplaceID: \(id)\n")
        return Single<BaseResponseDTO<WorkplaceDTO>>.create { observer in
            observer(.success(MockData.WorkplaceAPI.detailSuccess))
            return Disposables.create()
        }
        .map { try $0.toDomain() }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    func updateWorkplace(_ request: UpdateWorkplaceRequest) -> RxSwift.Single<Bool> {
        Swift.print(#fileID, #function, "\n- request: \(request)\n")
        return Single<BaseResponseDTO<Bool>>.create { observer in
            observer(.success(MockData.WorkplaceAPI.updateSuccess))
            return Disposables.create()
        }
        .map { $0.isSuccess }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    func deleteWorkplace(workplaceIdentifier id: Workplace.ID) -> RxSwift.Single<Bool> {
        Swift.print(#fileID, #function, "\n- workplaceID: \(id)\n")
        return Single<BaseResponseDTO<Bool>>.create { observer in
            observer(.success(MockData.WorkplaceAPI.deleteSuccess))
            return Disposables.create()
        }
        .map { $0.isSuccess }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    func submitApplication(workplaceIdentifier id: Workplace.ID) -> RxSwift.Single<Bool> {
        Swift.print(#fileID, #function, "\n- workplaceID: \(id)\n")
        return Single<BaseResponseDTO<Bool>>.create { observer in
            observer(.success(MockData.WorkplaceAPI.submitApplicationSuccess))
            return Disposables.create()
        }
        .map { $0.isSuccess }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    func acceptApplication(
        workplaceApproveId: String,
        workplaceJoinHistoryId: String
    ) -> RxSwift.Single<Bool> {
        Swift.print(#fileID, #function, "\n- workplaceApproveId: \(workplaceApproveId)\n- workplaceJoinHistoryId: \(workplaceJoinHistoryId)\n")
        return Single<BaseResponseDTO<Bool>>.create { observer in
            observer(.success(MockData.WorkplaceAPI.acceptApplicationSuccess))
            return Disposables.create()
        }
        .map { $0.isSuccess }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    func denyApplication(
        workplaceApproveId: String,
        workplaceJoinHistoryId: String
    ) -> RxSwift.Single<Bool> {
        Swift.print(#fileID, #function, "\n- workplaceApproveId: \(workplaceApproveId)\n- workplaceJoinHistoryId: \(workplaceJoinHistoryId)\n")
        return Single<BaseResponseDTO<Bool>>.create { observer in
            observer(.success(MockData.WorkplaceAPI.denyApplicationSuccess))
            return Disposables.create()
        }
        .map { $0.isSuccess }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
}
