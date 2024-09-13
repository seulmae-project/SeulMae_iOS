//
//  WorkeInfo.swift
//  SeulMae
//
//  Created by 조기열 on 9/13/24.
//

import Foundation

struct WorkeInfo {
    let workedDays: Int
    let firstWorkDate: Date
    let payday: Int
}

struct WorkeInfoDTO: ModelType {
    let workedDays: Int
    let firstWorkDate: Date
    let payday: Int
}

extension BaseResponseDTO<WorkeInfoDTO> {
    func toDomain() -> WorkeInfo? {
        return data?.toDomain()
    }
}

extension WorkeInfoDTO {
    func toDomain() -> WorkeInfo {
        .init(
            workedDays: self.workedDays,
            firstWorkDate: self.firstWorkDate,
            payday: self.payday
        )
    }
}
