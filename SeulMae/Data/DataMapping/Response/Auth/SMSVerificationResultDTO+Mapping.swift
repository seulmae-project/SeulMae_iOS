//
//  SMSVerificationResultDTO.swift
//  SeulMae
//
//  Created by 조기열 on 11/2/24.
//

import Foundation

struct SMSVerificationResultDTO: ModelType {
    let accountId: String?
    let isSuccess: Bool?
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<SMSVerificationResultDTO> {
    func toDomain() throws -> SMSVerificationResult {
        return try getData().toDomain()
    }
}

extension SMSVerificationResultDTO {
    func toDomain() -> SMSVerificationResult {
        return .init(
            accountId: self.accountId ?? "",
            isSuccess: self.isSuccess ?? false
        )
    }
}


