//
//  WorkplacesResponseDTO+Mapping.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation

struct WorkplacesResponseDTO: ModelType {
    let workplaceId: Int
    let workplaceCode: String
    let workplaceName: String
    let workplaceTel: String
    let workplaceImageUrl: String
    let workplaceManagerName: String
    let subAddress: String
    let mainAddress: String
}

[
    {
        "workplaceId": 1,
        "workplaceCode": "861cd263-c4fb-4d82-9839-f61a68c63130",
        "workplaceName": "슬매",
        "workplaceTel": "01012341234",
        "workplaceImageUrl": null,
        "workplaceManagerName": null,
        "workplaceThumbnailUrl": "http://localhost:8080/api/workplace/v1/file?workplaceImageId=1",
        "subAddress": "안양이지롱",
        "mainAddress": "경기도지롱"
    }
]
