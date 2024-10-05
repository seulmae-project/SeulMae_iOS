//
//  MemberProfileDto+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 7/20/24.
//

import Foundation

struct MemberProfileDto: ModelType {
    let name: String
    // TODO: - Kakao 로 로그인한 경우 휴대폰번호가 없음
    let phoneNumber: String?
    let imageURL: String?
    let joinDate: Date
    let workScheduleList: [WorkScheduleDTO]?
    let payDay: Int
    let baseWage: Int
    let memo: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case phoneNumber
        case imageURL
        case joinDate
        case workScheduleList = "workScheduleDtoList"
        case payDay
        case baseWage
        case memo
    }
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<MemberProfileDto> {
    func toDomain() -> MemberProfile {
        return data!.toDomain()
    }
}

extension MemberProfileDto {
    func toDomain() -> MemberProfile {
        return .init(
            name: name,
            phoneNumber: phoneNumber ?? "",
            imageURL: imageURL,
            joinDate: joinDate,
            workScheduleList: workScheduleList?.map { $0.toDomain() } ?? [],
            payDay: payDay,
            baseWage: baseWage,
            memo: memo ?? ""
        )
    }
}
