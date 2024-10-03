//
//  WorkplaceModel+CoreDataProperties.swift
//  SeulMae
//
//  Created by 조기열 on 10/3/24.
//
//

import Foundation
import CoreData


extension WorkplaceModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkplaceModel> {
        return NSFetchRequest<WorkplaceModel>(entityName: "WorkplaceModel")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var isManager: Bool
    @NSManaged public var invitationCode: String?
    @NSManaged public var mainAddress: String?
    @NSManaged public var subAddress: String?
    @NSManaged public var manager: String?
    @NSManaged public var thumbnailURL: String?
    @NSManaged public var contact: String?
    @NSManaged public var accountId: String?

}

extension WorkplaceModel: Identifiable {

}
