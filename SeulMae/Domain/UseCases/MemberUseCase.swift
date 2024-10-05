//
//  MemberUseCase.swift
//  SeulMae
//
//  Created by 조기열 on 9/8/24.
//

import Foundation
import RxSwift

protocol MemberUseCase {
    //func fetchMemberList() -> RxSwift.Single<[Member]>
    func fetchMemberProfile(memberId: Member.ID) -> RxSwift.Single<MemberProfile>
}

final class DefaultMemberUseCase: MemberUseCase {
    
    private let memberRepository: MemberRepository = DefaultMemberRepository(network: UserNetworking())
    private let userRepository = UserRepository(network: UserNetworking())
//    
//    func fetchMemberList() -> RxSwift.Single<[Member]> {
//        let currnetWorkplaceId = userRepository.currentWorkplaceId
//        return memberRepository.fetchMemberList(workplaceId: currnetWorkplaceId)
//    }
    
    func fetchMemberProfile(memberId: Member.ID) -> RxSwift.Single<MemberProfile> {
        return memberRepository.fetchMemberProfile(memberId: memberId)
    }
}

protocol MemberRepository {
    // func fetchMemberList(workplaceId: Workplace.ID) -> RxSwift.Single<[Member]>
    func fetchMemberProfile(memberId: Member.ID) -> RxSwift.Single<MemberProfile>
}

class DefaultMemberRepository: MemberRepository {
    // MARK: - Dependancies
    
    private let network: UserNetworking
    
    // MARK: - Life Cycle Methods
    
    init(network: UserNetworking) {
        self.network = network
    }
    
//    func fetchMemberList(workplaceId: Workplace.ID) -> RxSwift.Single<[Member]> {
//        return network.rx
//            .request(.fetchMemberList(workplaceId: workplaceId))
//            .do(onSuccess: { response in
//                Swift.print("response: \(try response.mapString())")
//            }, onError: { error in
//                Swift.print("error: \(error)")
//            })
//            .map(BaseResponseDTO<[MemberDTO]>.self)
//            .map { $0.toDomain() }
//    }
//    
    func fetchMemberProfile(memberId: Member.ID) -> RxSwift.Single<MemberProfile> {
        return network.rx
            .request(.fetchUserProfile(userId: memberId))
            .map(BaseResponseDTO<MemberProfileDto>.self)
            .map { $0.toDomain() }
    }
}
