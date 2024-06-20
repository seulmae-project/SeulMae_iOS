//
//  EmailDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation

struct EmailDTO: ModelType {
    let email: String?
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<EmailDTO> {
    func toDomain() -> String {
        return data?.email ?? ""
    }
}

