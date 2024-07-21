//
//  MemberInfoDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 7/20/24.
//

import Foundation

struct MemberInfoDTO: ModelType {
    let name: String?
    let phoneNumber: String?
    let imageURL: String?
    let joinDate: Date? // 2024-07-19
    
    // let workSchedule: WorkSchedule
    let workScheduleIdentifier: Int?
    let workScheduleTitle: String?
    let days: [Int]?
    
    let payDay: Int?
    let baseWage: Int?
    let memo: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case phoneNumber
        case imageURL
        case joinDate
        case workScheduleIdentifier = "workScheduleId"
        case workScheduleTitle
        case days
        case payDay
        case baseWage
        case memo
    }
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<MemberInfoDTO> {
    func toDomain() throws -> MemberInfo {
        guard let data else {
            throw MappingError.emptyData(Data.self)
        }
        
        return try data.toDomain()
    }
}

extension MemberInfoDTO {
    func toDomain() throws -> MemberInfo {
        return .init(
            name: name,
            phoneNumber: phoneNumber,
            imageURL: imageURL,
            joinDate: joinDate,
            workScheduleIdentifier: workScheduleIdentifier,
            workScheduleTitle: workScheduleTitle,
            days: days,
            payDay: payDay,
            baseWage: baseWage,
            memo: memo
        )
    }
}
