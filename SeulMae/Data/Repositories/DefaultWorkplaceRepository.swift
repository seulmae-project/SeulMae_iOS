//
//  DefaultWorkplaceRepo.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import Foundation
import RxSwift
import Moya

//extension Moya.Response {
//    var toPrettyPrintedString: String? {
//        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
//              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
//              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
//        return prettyPrintedString as String
//    }
//    func mapPrettyString(atKeyPath keyPath: String? = nil) throws -> String {
//        if let keyPath = keyPath {
//            guard let jsonDictionary = try mapJSON() as? NSDictionary,
//                let string = jsonDictionary.value(forKeyPath: keyPath) as? String else {
//                    throw MoyaError.stringMapping(self)
//            }
//            return string
//        } else {
//            // Key path was not provided, parse entire response as string
//            guard let string = String(data: data, encoding: .utf8) else {
//                throw MoyaError.stringMapping(self)
//            }
//            return string
//        }
//    }
//}

final class DefaultWorkplaceRepository: WorkplaceRepository {
    private let network: WorkplaceNetworking
    private let storage: WorkplaceStorage
    
    init(network: WorkplaceNetworking, storage: WorkplaceStorage) {
        self.network = network
        self.storage = storage
    }
    
    func saveWorkplaces(_ workplaces: [Workplace], withAccount account: String) -> RxSwift.Single<Bool> {
        return .just(storage.saveWorkplaces(workplaces: workplaces, withAccount: account))
    }
    
    func fetchWorkplaces(keyword: String) -> RxSwift.Single<[Workplace]> {
        return network.rx
            .request(.fetchWorkplaces(keyword: ""))
            .do(onSuccess: { response in
                Swift.print("response: \(try response.mapString())")
                Swift.print("response2: \(NSString(data: response.data, encoding: String.Encoding.utf8.rawValue) ?? "")")
            }, onError: { error in
                Swift.print("error: \(error)")
            })
            .map(BaseResponseDTO<[WorkplaceDTO]>.self)
            .map { try $0.toDomain() }
    }
    
    enum SomeError: Error {
        case some
    }
    
    func fetchWorkplaces(accountID: String) -> Single<Array<[String: Any]>> {
        return Single.create { [weak self] single in
            guard let strongSelf = self else {
                single(.failure(SomeError.some))
                return Disposables.create()
            }
            
            let workplaces = strongSelf.storage.fetchWorkplaces(account: accountID)
            single(.success(workplaces))
            return Disposables.create()
        }
    }
    
    func addNewWorkplace(request: AddNewWorkplaceRequest) -> RxSwift.Single<Bool> {
        return network.rx
            .request(.addNewWorkplace(request: request))
            .do(onSuccess: { response in
                Swift.print("response: \(try response.mapString())")
                Swift.print("response2: \(NSString(data: response.data, encoding: String.Encoding.utf8.rawValue) ?? "")")
            }, onError: { error in
                Swift.print("error: \(error)")
            })
            .map(BaseResponseDTO<String?>.self)
            .map { $0.isSuccess }
    }
    
    func fetchWorkplaceDetail(workplaceID id: Workplace.ID) -> RxSwift.Single<Workplace> {
        return network.rx
            .request(.fetchWorkplaceDetail(workplaceID: id))
            .do(onSuccess: { response in
                Swift.print("response: \(try response.mapString())")
                Swift.print("response2: \(NSString(data: response.data, encoding: String.Encoding.utf8.rawValue) ?? "")")
            }, onError: { error in
                print(#function)
                Swift.print("error: \(error)")
            })
            .map(BaseResponseDTO<WorkplaceDTO>.self)
            .map { try $0.toDomain() }
    }
    
    func submitApplication(workplaceID id: Workplace.ID) -> RxSwift.Single<Bool> {
        return network.rx
            .request(.submitApplication(workplaceID: id))
            .do(onSuccess: { response in
                Swift.print("response: \(try response.mapString())")
                Swift.print("response2: \(NSString(data: response.data, encoding: String.Encoding.utf8.rawValue) ?? "")")
            }, onError: { error in
                Swift.print("error: \(error)")
            })
            .map(BaseResponseDTO<String?>.self)
            .map { $0.isSuccess }
    }
        
    func fetchMemberInfo(
        memberIdentifier id: Member.ID
    ) -> RxSwift.Single<MemberProfile> {
        return Single<BaseResponseDTO<MemberProfileDTO>>.create { observer in
            observer(.success(MockData.WorkplaceAPI.memberInfoSuccess))
            return Disposables.create()
        }
        .map { try $0.toDomain() }
        .do(onError: { error in
            print("error: \(error)")
        })
    }
    
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
