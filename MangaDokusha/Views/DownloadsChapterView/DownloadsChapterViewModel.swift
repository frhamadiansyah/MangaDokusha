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
    
    let fileManager = LocalFileManager.shared
    
    @Published var entity: MangaEntity
    
    @Published var chapters = [ChapterEntity]()
    
    @Published var mangaTitle = ""
    
    init(entity: MangaEntity) {
        self.entity = entity
        mangaTitle = entity.title ?? "No Title"
    }
    
    @MainActor
    func deleteItems(offsets: IndexSet) async {
        let mangaId = entity.id ?? ""
        offsets.map { chapters [$0] }.forEach { chapter in
            let chapterId = chapter.id ?? ""
            manager.delete(chapter)
            fileManager.deleteChapter(chapter: chapterId, manga: mangaId)
        }
        
        do {
            try await manager.save2()
            let count = try await fetchChapters()
            if count.isEmpty {
                try manager.delete(entity)
                try await manager.save2()
                throw MangaDokushaError.noChapter
            } else {
                chapters = count
            }
        } catch {
            basicHandleError(error)
        }
    }
    
    func fetchChapters() async throws -> [ChapterEntity] {
        let request = NSFetchRequest<ChapterEntity>(entityName: "ChapterEntity")
        
        let sort = NSSortDescriptor(keyPath: \ChapterEntity.chapter, ascending: true)
        request.sortDescriptors = [sort]
        
        let filter = NSPredicate(format: "manga == %@", entity)
        request.predicate = filter
        
        return try await manager.context.perform {
            return try request.execute()
        }
    }
    
    @MainActor
    func getChapters() async {
        do {
            chapters = try await fetchChapters()
        } catch let err {
            basicHandleError(err)
        }
        
    }
    
}
