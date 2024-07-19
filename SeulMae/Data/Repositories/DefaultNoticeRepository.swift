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
    
    // MARK: - Main
    
    func fetchMemberList(_ workplaceID: String) -> RxSwift.Single<[Member]> {
        .error(APIError.faildedToSignup)
    }
    
    // MARK: - Workplace
    
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
    
    func fetchWorkplaceDetail(_ workplaceID: String) -> RxSwift.Single<Workplace> {
        Swift.print(#fileID, #function, "\n- workplaceID: \(workplaceID)\n")
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
    
    func deleteWorkplace(_ workplaceID: String) -> RxSwift.Single<Bool> {
        Swift.print(#fileID, #function, "\n- workplaceID: \(workplaceID)\n")
        return Single<BaseResponseDTO<Bool>>.create { observer in
            observer(.success(MockData.WorkplaceAPI.deleteSuccess))
            return Disposables.create()
        }
        .map { $0.isSuccess }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    func submitApplication(_ workplaceID: String) -> RxSwift.Single<Bool> {
        Swift.print(#fileID, #function, "\n- workplaceID: \(workplaceID)\n")
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
    
    // MARK: - Notice
    
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
        noticeID: String,
        _ request: UpdateNoticeRequest
    ) -> RxSwift.Single<Bool> {
        Swift.print(#fileID, #function, "\n- noticeID: \(noticeID)\n - request: \(request)\n")
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
    
    func fetchNoticeDetail(noticeID: String) -> RxSwift.Single<NoticeDetail> {
        Swift.print(#fileID, #function, "\n- noticeID: \(noticeID)\n")
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
    
    func fetchAllNotice(workplaceID: String, page: Int, size: Int) -> RxSwift.Single<[Notice]> {
        Swift.print(#fileID, #function, "\n- workplaceID: \(workplaceID)\n - page: \(page)\n - size: \(size)\n")
        return Single<BaseResponseDTO<[NoticeDTO]>>.create { observer in
            observer(.success(MockData.NoticeAPI.noticesSuccess))
            // observer(.success(MockData.NoticeAPI.noticesFailed))
            return Disposables.create()
        }
        .map { try $0.toDomain() }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    func fetchMustReadNoticeList(workplaceID: Int) -> RxSwift.Single<[Notice]> {
        Swift.print(#fileID, #function, "\n- workplaceID: \(workplaceID)\n")
        return Single<BaseResponseDTO<[NoticeDTO]>>.create { observer in
            observer(.success(MockData.NoticeAPI.mustReadNoticesSuccess))
            return Disposables.create()
        }
        .map { try $0.toDomain() }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    func fetchMainNoticeList(workplaceID: Int) -> RxSwift.Single<[Notice]> {
        Swift.print(#fileID, #function, "\n- workplaceID: \(workplaceID)\n")
        return Single<BaseResponseDTO<[NoticeDTO]>>.create { observer in
            observer(.success(MockData.NoticeAPI.mainNoticesSuccess))
            return Disposables.create()
        }
        .map { try $0.toDomain() }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
    func deleteNotice(noticeID: Int) -> RxSwift.Single<Bool> {
        Swift.print(#fileID, #function, "\n- noticeID: \(noticeID)\n")
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
