//
//  BaseResponseDTO.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation

struct BaseResponseDTO<T: ModelType>: ModelType {
    let data: T?
    let status: Int?
    let resultMsg: String?
    let divisionCode: String?
    let errors: [String]?
    let reason: String?
}
