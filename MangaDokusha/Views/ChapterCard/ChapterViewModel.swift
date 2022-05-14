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
    
    var readChapterService = ReadChapterService(apiService: APIService())
    
    @Published var imageUrls = [String]()
    
    init(manga: MangaModel?, chapter: ChapterModel) {
        self.manga = manga
        self.chapter = chapter
    
    }
    
    @Published var isDownloaded = false
    
    func getChapterImageRequest() -> URLRequest {
        return readChapterService.getReadChapterRequest(chapterId: chapter.id)
    }
    
    func loadChapterImageUrl(request: URLRequest, completion: @escaping ([String]) -> Void) {
        imageUrls = []
        readChapterService.getChapterImageModel(request: request)
            .sink { error in
                self.basicHandleCompletionError(error: error)
                completion([])
            } receiveValue: { model in
                self.imageUrls.append(contentsOf: model.saverImageUrls)
                completion(model.saverImageUrls)
            }.store(in: &cancel)
    }
    
    func downloadChapter() {
        let request = getChapterImageRequest()
        loadChapterImageUrl(request: request) { array  in
            if array.count > 0 {
                self.addChapter(pageUrls: array)
            }
        }
    }
    
    
    func addChapter(pageUrls: [String]) {

        let newChapter = ChapterEntity(context: manager.context)
        
        newChapter.translateChapterModel(model: chapter)
        
        newChapter.pageCount = Int16(pageUrls.count)
        
        for (index, element) in pageUrls.enumerated() {
            let page = PageEntity(context: manager.context)
            page.chapterId = chapter.id
            page.pageNumber = Int16(index)
            page.id = element
            newChapter.addToPages(page)
        }
        
        if let manga = manga {
            
            if let coreManga = getMangaFromPersistence() {
                newChapter.manga = coreManga
            } else {
                let newManga = MangaEntity(context: manager.context)
                newManga.translateMangaModel(model: manga)
                newChapter.manga = newManga
            }
            
        }
        save { result in
            if result {
                self.isDownloaded = true
            }
        }
        
    }
    
    func checkIfDownloaded() {
        let request = NSFetchRequest<ChapterEntity>(entityName: "ChapterEntity")
        
        let filter = NSPredicate(format: "id == %@", chapter.id)
        request.predicate = filter
        
        do {
            let chapterExist = try manager.context.fetch(request)
            if !chapterExist.isEmpty {
                self.isDownloaded = true
            }
        } catch let error {
            print("Error fetching : \(error.localizedDescription)")
            self.error = MangaDokushaError.otherError(error)
            self.showError = true
        }

    }
    
    func getMangaFromPersistence() -> MangaEntity? {
        
        let request = NSFetchRequest<MangaEntity>(entityName: "MangaEntity")
        request.fetchLimit = 1
        
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
    
    func save(completion: @escaping (Bool) -> Void) {
        do {
            try manager.save()
            completion(true)
        } catch let err {
            self.error = MangaDokushaError.otherError(err)
            self.showError = true
            completion(false)
        }
    }
    
}
