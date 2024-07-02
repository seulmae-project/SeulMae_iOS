//
//  BaseResponseDTO.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation

struct BaseResponseDTO<Data: Codable>: ModelType {
    let data: Data?
    let status: Int?
    let resultMsg: String?
    let divisionCode: String?
    let errors: [String]?
    let reason: String?
    
    var isSuccess: Bool {
        guard let status else {
            return false
        }
        
        let successCodes = [200, 201]
        return successCodes.contains(status)
    }
}
