//
//  SearchWorkplaceItem.swift
//  SeulMae
//
//  Created by 조기열 on 9/29/24.
//

import Foundation

struct SearchWorkplaceItem: Hashable {
    
    let id: Workplace.ID
    let placeName: String
    let placeAddress: String
    let placeTel: String
    let placeMananger: String
    let imageUrl: String
    
    init(workplace: Workplace) {
        self.id = workplace.id
        self.placeName = workplace.name
        self.placeAddress = (workplace.mainAddress + (workplace.subAddress ?? ""))
        self.placeTel = workplace.contact
        self.placeMananger = workplace.manager ?? ""
        self.imageUrl = workplace.thumbnailURL ?? ""
    }
}
