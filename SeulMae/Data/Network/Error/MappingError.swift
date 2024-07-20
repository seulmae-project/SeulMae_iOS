//
//  MappingError.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import Foundation

enum MappingError: Error {
    case emptyData(_ model: ModelType.Type)
    case invalidData(_ model: ModelType.Type)
}
