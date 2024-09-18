//
//  WorkInfo.swift
//  SeulMae
//
//  Created by 조기열 on 9/13/24.
//

import Foundation

struct WorkInfo {
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
    func toDomain() -> WorkInfo? {
        return data?.toDomain()
    }
}

extension WorkeInfoDTO {
    func toDomain() -> WorkInfo {
        .init(
            workedDays: self.workedDays,
            firstWorkDate: self.firstWorkDate,
            payday: self.payday
        )
    }
}
