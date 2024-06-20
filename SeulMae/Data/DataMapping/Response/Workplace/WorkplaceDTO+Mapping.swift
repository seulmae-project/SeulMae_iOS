//
//  WorkplaceDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation

struct WorkplaceDTO: ModelType {
    let workplaceId: Int?
    let workplaceCode: String?
    let workplaceName: String?
    let workplaceTel: String?
    let workplaceImageUrl: [String]?
    let workplaceManagerName: String?
    let subAddress: String?
    let mainAddress: String?
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<[WorkplaceDTO]> {
    func toDomain() -> [Workplace] {
        data?.map { $0.toDomain() } ?? []
    }
}

extension WorkplaceDTO {
    func toDomain() -> Workplace {
        return .init(
            workplaceId: workplaceId ?? 0,
            workplaceCode: workplaceCode ?? "",
            workplaceName: workplaceName ?? "",
            workplaceTel: workplaceTel ?? "",
            workplaceImageUrl: workplaceImageUrl ?? [],
            workplaceManagerName: workplaceManagerName ?? "",
            subAddress: subAddress ?? "",
            mainAddress: mainAddress ?? ""
        )
    }
}
