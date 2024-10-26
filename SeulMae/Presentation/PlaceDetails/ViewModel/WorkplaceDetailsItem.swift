//
//  WorkplaceDetailsItem.swift
//  SeulMae
//
//  Created by 조기열 on 9/29/24.
//

import Foundation

struct WorkplaceDetailsItem {
    let imageUrl: String
    let name: String
    let contact: String
    let address: String
    let manager: String
    
    init(workplace: Workplace) {
        self.imageUrl = workplace.thumbnailURL ?? ""
        self.name = workplace.name
        self.contact = workplace.contact
        self.address = workplace.mainAddress
        self.manager = workplace.manager ?? ""
    }
}
