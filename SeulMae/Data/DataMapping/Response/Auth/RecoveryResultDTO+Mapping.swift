//
//  RecoveryResultDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 11/2/24.
//

import Foundation

struct RecoveryResultDTO: ModelType {}

// MARK: - Mappings To Domain

extension BaseResponseDTO<RecoveryResultDTO> {
    func toDomain() -> RecoveryResult {
        return .init(
            isRecovery: self.isSuccess,
            message: self.errorDescription ?? ""
        )
    }
}
