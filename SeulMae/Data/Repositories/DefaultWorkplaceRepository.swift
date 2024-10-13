//
//  DefaultWorkplaceRepo.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import Foundation
import RxSwift
import Moya


final class DefaultWorkplaceRepository: WorkplaceRepository {
    
    private let network: WorkplaceNetworking
    private let storage: WorkplaceStorage
    private let storage2 = WorkplaceModelDataSource()
    
    init(network: WorkplaceNetworking, storage: WorkplaceStorage) {
        self.network = network
        self.storage = storage
    }
    
    // MARK: - Local DB
    
    func create(workplaceList: [Workplace], accountId: String) -> Bool {
        return storage2.create(workplaceList: workplaceList, accountId: accountId)
    }
    
    func read(accountId: String) -> [Workplace] {
        return storage2.load(accountId: accountId)
    }
    
    func read(workplaceId: Workplace.ID) -> Workplace {
        return storage2.load(workplaceId: workplaceId)
    }
    
    // MARK: - API
    
    func fetchWorkplaceList(keyword: String) -> RxSwift.Single<[Workplace]> {
        return network.rx
            .request(.fetchWorkplaceList(keyword: keyword))
            .map(BaseResponseDTO<[WorkplaceDTO]>.self)
            .map { $0.toDomain() }
    }
    
    enum SomeError: Error {
        case some
    }
    
    
    
    func addNewWorkplace(request: AddNewWorkplaceRequest) -> RxSwift.Single<Bool> {
        return network.rx
            .request(.addWorkplace(request: request, data: Data()))
            .do(onSuccess: { response in
                Swift.print("response: \(try response.mapString())")
                Swift.print("response2: \(NSString(data: response.data, encoding: String.Encoding.utf8.rawValue) ?? "")")
            }, onError: { error in
                Swift.print("error: \(error)")
            })
            .map(BaseResponseDTO<String?>.self)
            .map { $0.isSuccess }
    }
    
    func fetchWorkplaceDetail(workplaceId: Workplace.ID) -> RxSwift.Single<Workplace> {
        return network.rx
            .request(.fetchWorkplaceDetails(workplaceId: workplaceId))
            .map(BaseResponseDTO<WorkplaceDTO>.self)
            .map { $0.toDomain() }
    }
    
    func submitApplication(workplaceId: Workplace.ID) -> RxSwift.Single<Bool> {
        return network.rx
            .request(.submitApplication(workplaceId: workplaceId))
            .map(BaseResponseDTO<String?>.self)
            .map { $0.isSuccess }
    }
    
    func fetchMemberList(workplaceId: Workplace.ID) -> RxSwift.Single<[Member]> {
        return network.rx
            .request(.memberList(workplaceId: workplaceId))
            .map(BaseResponseDTO<[MemberDTO]>.self)
            .map { $0.toDomain() }
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
    
    func deleteWorkplace(workplaceId: Workplace.ID) -> RxSwift.Single<Bool> {
        return Single<BaseResponseDTO<Bool>>.create { observer in
            observer(.success(MockData.WorkplaceAPI.deleteSuccess))
            return Disposables.create()
        }
        .map { $0.isSuccess }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    func acceptApplication(
        workplaceApproveId: Int,
        initialUserInfo: InitialUserInfo
    ) -> RxSwift.Single<Bool> {
        return network.rx
            .request(.acceptApplication(workplaceApproveId: workplaceApproveId, initialUserInfo: initialUserInfo))
            .map(BaseResponseDTO<Bool>.self)
            .map { $0.isSuccess }
    }
    
    func denyApplication(workplaceApproveId: Int) -> RxSwift.Single<Bool> {
        return network.rx
            .request(.denyApplication(workplaceApproveId: workplaceApproveId))
            .map(BaseResponseDTO<Bool>.self)
            .map { $0.isSuccess }
    }
    
    
    func fetchMemberInfo(memberId: Member.ID) -> RxSwift.Single<MemberProfile> {
        return network.rx
            .request(.memberDetails(userId: memberId))
            .map(BaseResponseDTO<MemberProfileDto>.self)
            .map { $0.toDomain() }
    }

    

    func fetchMyInfo(workplaceId: Workplace.ID) -> RxSwift.Single<MemberProfile> {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return network.rx
            .request(.myDetails(workplaceId: workplaceId))
            .map(BaseResponseDTO<MemberProfileDto>.self, using: decoder)
            .map { $0.toDomain() }
    }
    
    func fetchJoinedWorkplaceList() -> RxSwift.Single<[Workplace]> {
        return network.rx
            .request(.fetchJoinedWorkplaceList)
            .map(BaseResponseDTO<[WorkplaceDTO]>.self)
            .map { $0.toDomain() }
    }
}
