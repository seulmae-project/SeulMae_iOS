//
//  WorkplaceModelDataSource.swift
//  SeulMae
//
//  Created by 조기열 on 10/3/24.
//

import Foundation
import CoreData

class WorkplaceModelDataSource {
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SeulmaeLocalDB")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() -> Bool {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch {
                return false
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        return true
    }
    
    func create(workplaceList: [Workplace], accountId: String) -> Bool {
        workplaceList.forEach { workplace in
            let entity = WorkplaceModel(context: persistentContainer.viewContext)
            entity.accountId = accountId
            entity.id = Int32(workplace.id)
            entity.name = workplace.name
            entity.isManager = workplace.isManager ?? false
            entity.invitationCode = workplace.invitationCode
            entity.mainAddress = workplace.mainAddress
            entity.subAddress = workplace.subAddress ?? ""
            entity.manager = workplace.manager ?? ""
            entity.thumbnailURL = workplace.thumbnailURL ?? ""
            entity.contact = workplace.contact
        }
        return saveContext()
    }
    
    func load(accountId: String) -> [Workplace] {
        let request = WorkplaceModel.fetchRequest()
        request.predicate = NSPredicate(format: "accountId = %@", accountId)
        let context = persistentContainer.viewContext
        guard let models = try? context.fetch(request) else { return [] }
        Swift.print("[DB] accountId: \(accountId), workplaceListCount: \(models.count)" )
        return models.map(Workplace.init(entity: ))
    }
    
    func load(workplaceId: Workplace.ID) -> Workplace {
        let request = WorkplaceModel.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d", workplaceId)
        let context = persistentContainer.viewContext
        guard let models = try? context.fetch(request),
              let matched = models.first else {
            Swift.fatalError()
        }
        
        let entity = Workplace.init(entity: matched)
        Swift.print("[DB]: matched: \(entity)")
        return entity
    }
}
