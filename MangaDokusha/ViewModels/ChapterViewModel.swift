//
//  ChapterViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 13/05/22.
//

import Foundation
import CoreData

class ChapterViewModel: BaseViewModel {
    
    let manager = CoreDataManager.instance
    
    var manga: MangaModel?
    
    var chapter: ChapterModel
    
    init(manga: MangaModel?, chapter: ChapterModel) {
        self.manga = manga
        self.chapter = chapter
    }
    
    @Published var isDownloaded = false
    
    
    func addChapter() {
//        guard isDownloaded else { return }
        
        let newChapter = ChapterEntity(context: manager.context)
        
        newChapter.id = chapter.id
        newChapter.chapter = chapter.chapter
        
        if let manga = manga {
            
            if let coreManga = getMangaFromPersistence() {
                newChapter.manga = coreManga
            } else {
                let newManga = MangaEntity(context: manager.context)
                newManga.id = manga.id
                
                guard let cover = manga.cover?.coverUrl else {return}
                newManga.coverUrl = cover
                
                newManga.title = manga.title
                
                newChapter.manga = newManga
            }
            
        }
        save()
    }
    
    func checkIfDownloaded() {
        let request = NSFetchRequest<ChapterEntity>(entityName: "ChapterEntity")
        
        let sort = NSSortDescriptor(keyPath: \ChapterEntity.chapter, ascending: true)
        request.sortDescriptors = [sort]
        
        let filter = NSPredicate(format: "id == %@", chapter.id)
        request.predicate = filter
        do {
            let chapterExist = try manager.context.fetch(request)
            if !chapterExist.isEmpty {
                self.isDownloaded = true
            }
        } catch let error {
            print("Error fetching : \(error.localizedDescription)")
        }

    }
    
    func downloadChapter() {
        let request = NSFetchRequest<ChapterEntity>(entityName: "ChapterEntity")
        
        let sort = NSSortDescriptor(keyPath: \ChapterEntity.chapter, ascending: true)
        request.sortDescriptors = [sort]
        
        let filter = NSPredicate(format: "id == %@", chapter.id)
        request.predicate = filter
        do {
            let chapterExist = try manager.context.fetch(request)
            if !chapterExist.isEmpty {
                self.isDownloaded = true
            } else {
                self.addChapter()
                self.isDownloaded = true
            }
        } catch let error {
            print("Error fetching : \(error.localizedDescription)")
        }
        
    }
    
    func getMangaFromPersistence() -> MangaEntity? {
        let request = NSFetchRequest<MangaEntity>(entityName: "MangaEntity")
        
        let sort = NSSortDescriptor(keyPath: \MangaEntity.title, ascending: true)
        request.sortDescriptors = [sort]
        guard let manga = manga else {return nil}
        let filter = NSPredicate(format: "id == %@", manga.id)
        request.predicate = filter
        do {
            let coreManga = try manager.context.fetch(request)
            if !coreManga.isEmpty {
                return coreManga.first
            }
        } catch let err {
            print("Error fetching : \(err.localizedDescription)")
            self.error = MangaDokushaError.otherError(err)
            self.showError = true
        }
        return nil
    }
    
    func save() {
        do {
            try manager.save()
        } catch let err {
            self.error = MangaDokushaError.otherError(err)
            self.showError = true
        }
    }
    
}
