//
//  DefaultNoticeRepository.swift
//  SeulMae
//
//  Created by 조기열 on 6/22/24.
//

import Moya
import RxMoya
import RxSwift

class DefaultNoticeRepository: NoticeRepository {
    
    // MARK: - Dependancies
    
    private let network: MainNetworking
    
    // MARK: - Life Cycle Methods
    
    init(network: MainNetworking) {
        self.network = network
    }
    
    func addNotice(_ request: AddNoticeRequset) -> RxSwift.Single<Bool> {
        Swift.print(#fileID, #function, "\n- request: \(request)\n")
        return Single<BaseResponseDTO<Bool>>.create { observer in
            observer(.success(MockData.NoticeAPI.addSuccess))
            // observer(.success(MockData.NoticeAPI.addFailed))
            return Disposables.create()
        }
        .map { $0.isSuccess }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    func updateNotice(
        noticeIdentifier id: Notice.ID,
        _ request: UpdateNoticeRequest
    ) -> RxSwift.Single<Bool> {
        Swift.print(#fileID, #function, "\n- noticeID: \(id)\n - request: \(request)\n")
        return Single<BaseResponseDTO<Bool>>.create { observer in
            observer(.success(MockData.NoticeAPI.updateSuccess))
            // observer(.success(MockData.NoticeAPI.updateFailed))
            return Disposables.create()
        }
        .map { $0.isSuccess }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    func fetchNoticeDetail(noticeIdentifier id: Notice.ID) -> RxSwift.Single<NoticeDetail> {
        Swift.print(#fileID, #function, "\n- noticeID: \(id)\n")
        return Single<BaseResponseDTO<NoticeDetailDTO>>.create { observer in
            observer(.success(MockData.NoticeAPI.detailSuccess))
            // observer(.success(MockData.NoticeAPI.detailFailed))
            return Disposables.create()
        }
        .map { try $0.toDomain() }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    func fetchAllNotice(
        workplaceIdentifier id: Workplace.ID,
        page: Int,
        size: Int
    ) -> RxSwift.Single<[Notice]> {
        Swift.print(#fileID, #function, "\n- workplaceID: \(id)\n - page: \(page)\n - size: \(size)\n")
        return Single<[Notice]>.create { observer in
            let notices = MockData.NoticeAPI
                .noticesSuccess
                .compactMap { try? $0.toDomain() }
            observer(.success(notices))
            // observer(.success(MockData.NoticeAPI.noticesFailed))
            return Disposables.create()
        }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    func fetchMustReadNoticeList(workplaceIdentifier id: Workplace.ID) -> RxSwift.Single<[Notice]> {
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
    
    func fetchMainNoticeList(workplaceIdentifier id: Workplace.ID) -> RxSwift.Single<[Notice]> {
        Swift.print(#fileID, #function, "\n- workplaceID: \(id)\n")
        return Single<BaseResponseDTO<[NoticeDTO]>>.create { observer in
            observer(.success(MockData.NoticeAPI.mainNoticesSuccess))
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
