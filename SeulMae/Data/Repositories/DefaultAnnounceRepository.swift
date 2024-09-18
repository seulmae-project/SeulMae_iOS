//
//  DefaultAnnounceRepository.swift
//  SeulMae
//
//  Created by 조기열 on 9/8/24.
//

import Moya
import RxMoya
import RxSwift

protocol AnnounceRepository {
    func fetchMainAnnounceList(workplaceId id: Workplace.ID) -> Single<[Announce]>
    func fetchAnnounceList(workplaceId id: Workplace.ID, page: Int, size: Int) -> Single<[Announce]>
    func addAnnounce(request: AddAnnounceRequset) -> Single<Bool>
    func updateAnnounce(announceId id: Announce.ID, request: UpdateAnnounceRequest) -> Single<Bool>
    func fetchAnnounceDetail(announceId id: Announce.ID) -> Single<AnnounceDetail>
    func fetchMustReadNoticeList(workplaceIdentifier id: Workplace.ID) -> Single<[Announce]>
    func deleteNotice(noticeIdentifier id: Announce.ID) -> Single<Bool>
}

class DefaultAnnounceRepository: AnnounceRepository {
   
    // MARK: - Dependancies
    
    private let network: AnnounceNetworking
    
    // MARK: - Life Cycle Methods
    
    init(network: AnnounceNetworking) {
        self.network = network
    }
    
    func fetchAnnounceList(workplaceId id: Workplace.ID, page: Int, size: Int) -> RxSwift.Single<[Announce]> {
        return network.rx
            .request(.fetchAnnounceList(workplaceId: id, page: page, size: size))
            .do(onSuccess: { response in
                Swift.print("response: \(try response.mapString())")
            }, onError: { error in
                Swift.print("error: \(error)")
            })
            .map([NoticeDTO].self, atKeyPath: "data.data")
            .map { try $0.map { try $0.toDomain() } }
    }
    
    func fetchMainAnnounceList(workplaceId id: Workplace.ID) -> RxSwift.Single<[Announce]> {
        return network.rx
            .request(.fetchMainAnnounceList(workplaceId: id))
            .do(onSuccess: { response in
                Swift.print("response: \(try response.mapString())")
            }, onError: { error in
                Swift.print("error: \(error)")
            })
            .map(BaseResponseDTO<[NoticeDTO]>.self)
            .map { try $0.toDomain() }
    }
    
    func fetchAnnounceDetail(announceId id: Announce.ID) -> RxSwift.Single<AnnounceDetail> {
        return network.rx
            .request(.fetchAnnounceDetail(announceId: id))
            .map(BaseResponseDTO<AnnounceDetailDTO>.self, using: BaseResponseDTO<AnnounceDetailDTO>.decoder)
            .map { try $0.toDomain() }
    }
    
    func addAnnounce(request: AddAnnounceRequset) -> RxSwift.Single<Bool> {
        return network.rx
            .request(.addAnnounce(request: request))
            .map(BaseResponseDTO<String>.self)
            .map(\.isSuccess)
    }
    
    func updateAnnounce(
        announceId id: Announce.ID,
        request: UpdateAnnounceRequest
    ) -> RxSwift.Single<Bool> {
        return network.rx
            .request(.updateAnnounce(announceId: id, request: request))
            .do(onSuccess: { response in
                Swift.print("response: \(response.request?.url?.absoluteString)")
                Swift.print("response: \(try response.data.prettyString())")
            }, onError: { error in
                Swift.print("error: \(error)")
            })
            .map(BaseResponseDTO<String>.self)
            .map(\.isSuccess)
    }
    
    func fetchMustReadNoticeList(workplaceIdentifier id: Workplace.ID) -> RxSwift.Single<[Announce]> {
        Swift.print(#fileID, #function, "\n- workplaceID: \(id)\n")
        return Single<BaseResponseDTO<[NoticeDTO]>>.create { observer in
            observer(.success(MockData.NoticeAPI.mustReadNoticesSuccess))
            return Disposables.create()
        }
        .map { try $0.toDomain() }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    func deleteNotice(noticeIdentifier id: Int) -> RxSwift.Single<Bool> {
        Swift.print(#fileID, #function, "\n- noticeID: \(id)\n")
        return Single<BaseResponseDTO<Bool>>.create { observer in
            observer(.success(MockData.NoticeAPI.deleteSuccess))
            // observer(.success(MockData.NoticeAPI.deleteFailed))
            return Disposables.create()
        }
        .map { $0.isSuccess }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
}

