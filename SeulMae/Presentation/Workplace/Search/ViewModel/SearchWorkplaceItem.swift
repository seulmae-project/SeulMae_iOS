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
    
    func toListItem() -> [SearchWorkplaceViewController.Item] {
        return workplaceList.map {
            SearchWorkplaceViewController.Item(
                id: $0.id,
                placeName: $0.name,
                placeAddress: ($0.mainAddress + ($0.subAddress ?? "")),
                placeTel: $0.contact,
                placeMananger: $0.manager ?? ""
            )
        }
    }
}
