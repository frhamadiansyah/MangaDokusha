//
//  ReadDownloadedViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 14/05/22.
//

import Foundation
import CoreData
import UIKit

class ReadDownloadedViewModel: BaseViewModel {
    
    let entity: ChapterEntity
    let manager = CoreDataManager.instance
    let fileManager = LocalFileManager.shared
    
    @Published var imageUrls = [String]()
    @Published var images = [UIImage]()
    
    @Published var pageTitle = ""
    
    init(entity: ChapterEntity) {
        self.entity = entity
    }
    
    func getPages() {
        pageTitle = "Chapter \(entity.chapter.toString())"
        
        let request = NSFetchRequest<PageEntity>(entityName: "PageEntity")
        
        let sort = NSSortDescriptor(keyPath: \PageEntity.pageNumber, ascending: true)
        request.sortDescriptors = [sort]
        
        let filter = NSPredicate(format: "chapter == %@", entity)
        request.predicate = filter
        
        do {
            let pages = try manager.context.fetch(request)
            imageUrls = pages.map({$0.id ?? ""})
            for i in pages {
                images.append(fileManager.getImage(name: i.id ?? "") ?? UIImage())
            }
        } catch let error {
            print("Error fetching : \(error.localizedDescription)")
        }

    }
}
