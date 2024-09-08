//
//  MemberProfileDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 7/20/24.
//

import Foundation

struct MemberProfileDTO: ModelType {
    let name: String?
    let phoneNumber: String?
    let imageURL: String?
    let joinDate: Date? // 2024-07-19
    let workScheduleDTO: WorkScheduleDTO?
    let payDay: Int?
    let baseWage: Int?
    let memo: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case phoneNumber
        case imageURL
        case joinDate
        case workScheduleDTO = "workScheduleDto"
        case payDay
        case baseWage
        case memo
    }
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<MemberProfileDTO> {
    func toDomain() throws -> MemberProfile {
        return try getData().toDomain()
    }
}

extension MemberProfileDTO {
    func toDomain() -> MemberProfile {
        return .init(
            name: name,
            phoneNumber: phoneNumber,
            imageURL: imageURL,
            joinDate: joinDate,
            workSchedule: workScheduleDTO?.toDomain(),
            payDay: payDay,
            baseWage: baseWage,
            memo: memo
        )
    }
}
