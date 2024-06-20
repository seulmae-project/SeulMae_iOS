//
//  SMSCertificationDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation

struct SMSCertificationDTO: ModelType {
    let email: String?
}

// MARK: - Mappings To Domain

extension BaseResponseDTO<SMSCertificationDTO> {
    func toDomain() -> String {
        return data?.email ?? ""
    }
}

