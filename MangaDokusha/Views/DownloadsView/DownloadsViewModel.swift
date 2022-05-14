//
//  DownloadsViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 13/05/22.
//

import Foundation
import CoreData

class DownloadsViewModel: BaseViewModel {
    let manager = CoreDataManager.instance
    @Published var mangas: [MangaEntity] = []
    
    func save() {
        do {
            try manager.save()
        } catch let err {
            self.error = MangaDokushaError.otherError(err)
            self.showError = true
        }
    }
    
    func deleteEntity(entity: NSManagedObject) {
        do {
            try manager.context.delete(entity)
            save()
            print("Delete success")
        } catch let err {
            self.error = MangaDokushaError.otherError(err)
            self.showError = true
        }
    }
    
    func getManga() {
        let request = NSFetchRequest<MangaEntity>(entityName: "MangaEntity")
        
        let sort = NSSortDescriptor(keyPath: \MangaEntity.title, ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            mangas = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching : \(error.localizedDescription)")
        }

    }
}
