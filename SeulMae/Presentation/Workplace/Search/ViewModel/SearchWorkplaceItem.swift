//
//  SearchWorkplaceItem.swift
//  SeulMae
//
//  Created by 조기열 on 9/29/24.
//

import Foundation

struct SearchWorkplaceItem {
    enum ItemType {
        
    }
    
    var workplaceList: [Workplace]
    
    init(workplaceList: [Workplace]) {
        self.workplaceList = workplaceList
    }
}
