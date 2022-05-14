//
//  ReadDownloadedViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 14/05/22.
//

import Foundation
import CoreData

class ReadDownloadedViewModel: BaseViewModel {
    
    let entity: ChapterEntity
    let manager = CoreDataManager.instance
    
    @Published var imageUrls = [String]()
    
    @Published var pageTitle = ""
    
    init(entity: ChapterEntity) {
        self.entity = entity
    }
    
    func getPages() {
        pageTitle = "Chapter \(entity.chapter ?? "")"
        
        let request = NSFetchRequest<PageEntity>(entityName: "PageEntity")
        
        let sort = NSSortDescriptor(keyPath: \PageEntity.pageNumber, ascending: true)
        request.sortDescriptors = [sort]
        
        let filter = NSPredicate(format: "chapter == %@", entity)
        request.predicate = filter
        
        do {
            let pages = try manager.context.fetch(request)
            imageUrls = pages.map({$0.id ?? ""})
        } catch let error {
            print("Error fetching : \(error.localizedDescription)")
        }

    }
}
