//
//  WorkplaceFinderItem.swift
//  SeulMae
//
//  Created by 조기열 on 10/1/24.
//

import Foundation

struct WorkplaceFinderItem: Hashable {
    enum ItemType {
        case join
        case pending
        case active
    }
    
    let type: ItemType
}
