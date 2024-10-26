//
//  PlaceSearchItem.swift
//  SeulMae
//
//  Created by 조기열 on 9/29/24.
//

import Foundation

struct PlaceSearchItem: Hashable {
    let id: String = UUID().uuidString
    var section: SearchWorkplaceViewController.Section?
    var workplace: Workplace

    init(place: Workplace) {
        self.section = .results
        self.workplace = place
    }
}
