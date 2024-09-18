//
//  MonthlyAttenanceSummary.swift
//  SeulMae
//
//  Created by 조기열 on 9/13/24.
//

import Foundation

struct MonthlyAttenanceSummary {
    let monthlyWage: Double
    let applyStartDate: Date
    let applyEndDate: Date
    let baseWage: Double
    let monthlyWorkTime: Int
}

struct MonthlyAttenanceSummaryDTO: ModelType {
    let monthlyWage: Double
    let applyStartDate: Date
    let applyEndDate: Date
    let baseWage: Double
    let monthlyWorkTime: Int?
}

extension BaseResponseDTO<MonthlyAttenanceSummaryDTO> {
    func toDomain() -> MonthlyAttenanceSummary? {
        return data.map { $0.toDomain() }
    }
}

extension MonthlyAttenanceSummaryDTO {
    func toDomain() -> MonthlyAttenanceSummary {
        return .init(
            monthlyWage: self.monthlyWage,
            applyStartDate: self.applyStartDate,
            applyEndDate: self.applyEndDate,
            baseWage: self.baseWage,
            monthlyWorkTime: self.monthlyWorkTime ?? 0
        )
    }
}

