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
    
    func getManga() {
        let request = NSFetchRequest<MangaEntity>(entityName: "MangaEntity")
        
        let sort = NSSortDescriptor(keyPath: \MangaEntity.title, ascending: true)
        request.sortDescriptors = [sort]
        
//        let filter = NSPredicate(format: "", <#T##args: CVarArg...##CVarArg#>)
//        request.predicate
        do {
            mangas = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching : \(error.localizedDescription)")
        }

    }
}
