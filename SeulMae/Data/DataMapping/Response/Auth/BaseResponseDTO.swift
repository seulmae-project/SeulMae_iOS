//
//  BaseResponseDTO.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation

//{
//  "status": 200,
//  "message": "LOGIN SUCCESS",
//  "data":
//  "timestamp": "2024-07-23T15:30:29.0993451"
//}


struct BaseResponseDTO<Data: Codable>: ModelType {
    let data: Data?
    let status: Int?
    let resultMsg: String?
    let divisionCode: String?
    let errors: [String]?
    let reason: String?
    
    // status 200
    // message LOGIN
    // data
    // timestamp
    
    var isSuccess: Bool {
        guard let status else {
            return false
        }
        
        let successCodes = [200, 201]
        return successCodes.contains(status)
    }

    func getData() throws -> Data {
        guard let data else { throw APIError.empty(code: status) }
        return data
    }

    enum APIError: Error {
        case empty(code: Int?)
    }
}
