//
//  WorkplaceListItem.swift
//  SeulMae
//
//  Created by 조기열 on 9/8/24.
//

import Foundation

struct WorkplaceListItem: Hashable {
    enum ItemType {
        case member, announce, workSchedule
    }
    
    let itemType: ItemType
    let member: Member?
    let announce: Announce?
    let workSchedule: WorkSchedule?
    
    init(member: Member) {
        self.itemType = .member
        self.member = member
        self.announce = nil
        self.workSchedule = nil
    }
    
    init(annouce: Announce) {
        self.itemType = .announce
        self.member = nil
        self.announce = annouce
        self.workSchedule = nil
    }
    
    init(workSchedule: WorkSchedule) {
        self.itemType = .workSchedule
        self.member = nil
        self.announce = nil
        self.workSchedule = workSchedule
    }
}
