//
//  WorkplaceFinderItem.swift
//  SeulMae
//
//  Created by 조기열 on 10/1/24.
//

import Foundation

struct WorkplaceFinderItem: Hashable {
    enum ItemType {
        case finder
        case sumitState
        case workplace
    }
    
    private let identifier = UUID()
    let type: ItemType
    let workplace: Workplace?
    
    init(workplace: Workplace) {
        self.type = .workplace
        self.workplace = workplace
    }
    
    init() {
        self.type = .finder
        self.workplace = nil
    }
}
