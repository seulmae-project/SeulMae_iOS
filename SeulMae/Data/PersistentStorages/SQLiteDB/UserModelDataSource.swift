//
//  UserModelDataSource.swift
//  SeulMae
//
//  Created by 조기열 on 10/3/24.
//

import Foundation
import CoreData

class UserModelDataSource {
//    
//    // MARK: - Core Data stack
//    
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "SeulmaeDB")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//    
//    // MARK: - Core Data Saving support
//    
//    func saveContext() {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//    
//    func load(id: Member.ID) -> Member? {
//        let request = WorkplaceModel.fetchRequest()
//        request.fetchLimit = 1
//        request.predicate = NSPredicate(format: "id = %@", id)
//        let context = persistentContainer.viewContext
//        guard let entity = try? context.fetch(request)[0] else { return nil }
//        return Workplace(entity: entity)
//    }
//    
//    func save(workplace: Workplace) {
//        let entity = WorkplaceModel(context: persistentContainer.viewContext)
//        entity.id = Int16(workplace.id)
//        entity.name = workplace.name
//        entity.isManager = workplace.isManager ?? false
//        entity.invitationCode = workplace.invitationCode
//        entity.mainAddress = workplace.mainAddress
//        entity.subAddress = workplace.subAddress
//        entity.manager = workplace.manager
//        entity.thumbnailURL = workplace.thumbnailURL
//        entity.contact = workplace.contact
//        saveContext()
//    }
}
