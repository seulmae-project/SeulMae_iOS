//
//  AddNewWorkplaceRequest.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import Foundation

struct AddNewWorkplaceRequest: ModelType {
    var workplaceName: String
    var mainAddress: String
    var subAddress: String
    var workplaceTel: String
}
