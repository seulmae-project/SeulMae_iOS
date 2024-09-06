//
//  AddressDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 9/6/24.
//

import Foundation

struct AddressDTO: Codable {
    let mainAddress: String?
    let subAddress: String?
}

// MARK: - Mappings To Domain

extension AddressDTO {
    func toDomain() -> Address {
        return .init(
            mainAddress: mainAddress ?? "",
            subAddress: subAddress ?? ""
        )
    }
}

