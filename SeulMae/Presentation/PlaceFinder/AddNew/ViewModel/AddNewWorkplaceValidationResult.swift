//
//  AddNewWorkplaceValidationResult.swift
//  SeulMae
//
//  Created by 조기열 on 8/13/24.
//

import Foundation

enum AddNewWorkplaceValidationResult {
    case name(result: ValidationResult)
    case contact(result: ValidationResult)
    case address(result: ValidationResult)
    
    var result: ValidationResult {
        switch self {
        case let .name(result: result),
            let .contact(result: result),
            let .address(result: result):
            return result
        }
    }
}
