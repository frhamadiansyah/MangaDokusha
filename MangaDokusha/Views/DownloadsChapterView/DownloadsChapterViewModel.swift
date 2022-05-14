//
//  DownloadsChapterViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 13/05/22.
//

import Foundation
import CoreData

class DownloadsChapterViewModel: BaseViewModel {
    
    let manager = CoreDataManager.instance
    
    @Published var entity: MangaEntity
    
    @Published var chapters = [ChapterEntity]()
    
    @Published var mangaTitle = ""
    
    init(entity: MangaEntity) {
        self.entity = entity
    }

    func save() {
        do {
            try manager.save()
        } catch let err {
            self.error = MangaDokushaError.otherError(err)
            self.showError = true
        }
    }
    
    func getChapter() {
        mangaTitle = entity.title ?? "No Title"
        
        let request = NSFetchRequest<ChapterEntity>(entityName: "ChapterEntity")
        
        let sort = NSSortDescriptor(keyPath: \ChapterEntity.chapter, ascending: true)
        request.sortDescriptors = [sort]
        
        let filter = NSPredicate(format: "manga == %@", entity)
        request.predicate = filter
        do {
            chapters = try manager.context.fetch(request)
        } catch let error {
            self.error = MangaDokushaError.otherError(error)
            self.showError = true
            print("Error fetching : \(error.localizedDescription)")
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
    
    func deleteChapter(chapter: ChapterEntity, completion: @escaping (Bool) -> Void) {
        guard let manga = chapter.manga else {return}
        let count = manga.chapters?.count
        deleteEntity(entity: chapter)
        if count == 1 {
            deleteEntity(entity: manga)
            completion(true)
        }
    }
}
