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
        do {
            try context.save()
            print("Save successfully")
        } catch let error {
            throw MangaDokushaError.otherError(error)
        }
        
    }
}
