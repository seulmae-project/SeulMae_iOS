//
//  AddWorkplaceRequest.swift
//  SeulMae
//
//  Created by 조기열 on 7/2/24.
//

import Foundation

struct AddWorkplaceRequest: ModelType {
    var workplaceName: String
    var mainAddress: String
    var subAddress: String
    var tel: String
}
