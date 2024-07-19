//
//  WorkplaceDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation

struct WorkplaceDTO: ModelType {
    let id: Int?
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
    func toDomain() throws -> [Workplace] {
        guard let data else {
            throw MappingError.emptyData(Data.self)
        }
        
        return data.compactMap { try? $0.toDomain() }
    }
}

extension BaseResponseDTO<WorkplaceDTO> {
    func toDomain() throws -> Workplace {
        guard let data else {
            throw MappingError.emptyData(Data.self)
        }
        
        return try data.toDomain()
    }
}

extension WorkplaceDTO {
    func toDomain() throws -> Workplace {
        guard let id else {
            throw MappingError.invalidData(Self.self)
        }
        
        return .init(
            id: id,
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
