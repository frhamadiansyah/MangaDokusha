//
//  CoreDataManager.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 13/05/22.
//

import Foundation
import CoreData

class CoreDataManager {
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading core data: \(error)")
            }
        }
        context = container.viewContext
    }
    
    func save() throws {
        if context.hasChanges {
            do {
                try self.context.save()
                print("Save successfully")
            } catch let error {
                throw MangaDokushaError.otherError(error)
            }
        }
        
    }
    
    func save2() async throws {
        if context.hasChanges {
            try await context.perform {
                do {
                    try self.context.save()
                } catch {
                    throw MangaDokushaError.otherError(error)
                    
                }
            }
        }
    }
    
    func delete(_ object: NSManagedObject) {
        context.delete(object)
    }
    
    func deleteAll() async throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MangaEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try await context.perform {
            _ = try? self.container.viewContext.execute(batchDeleteRequest)
        }
    }
}
