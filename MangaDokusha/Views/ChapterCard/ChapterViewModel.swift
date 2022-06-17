//
//  ChapterViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 13/05/22.
//

import Foundation
import CoreData
import UIKit

class ChapterViewModel: BaseViewModel {
    
    let manager = CoreDataManager.instance
    let fileManager = LocalFileManager.shared
    
    var manga: MangaModel?
    
    var chapter: ChapterModel
    
    var readChapterService = ReadChapterService(apiService: APIService())
    
    @Published var imageUrls = [String]()
    var fileNames = [String]()
    
    init(manga: MangaModel?, chapter: ChapterModel) {
        self.manga = manga
        self.chapter = chapter
    
    }
    
    @Published var isDownloaded = false
    @Published var isLoading = false
    
    func getChapterImageRequest() -> URLRequest {
        return readChapterService.getReadChapterRequest(chapterId: chapter.id)
    }
    
    
    func loadItems(from urlString: String) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: URL(string: urlString)!)
        return data
    }
    
    func downloadImagesModels() async throws -> ReadChapterModel {
        let request = getChapterImageRequest()
        let model = try await readChapterService.getChapterImageModel(request)
        return model
    }
    
    @MainActor
    func downloadChapter() async {
        isLoading = true
        do {
            let model = try await downloadImagesModels()
            await addChapter(pageUrls: model.saverImageUrls, fileName: model.saverFileName)
            self.isLoading = false
            self.isDownloaded = true
        } catch {
            self.isLoading = false
            basicHandleError(error)
        }
    }

    
    func addChapter(pageUrls: [String], fileName: [String]) async {
        let newChapter = ChapterEntity(context: manager.context)
        
        newChapter.translateChapterModel(model: chapter)
        
        newChapter.pageCount = Int16(pageUrls.count)
        
        guard let manga = manga else { return }

        var index = 0
        for item in zip(fileName, pageUrls) {
            let (name, url) = item
            
            let page = PageEntity(context: manager.context)
            page.chapterId = chapter.id
            page.pageNumber = Int16(index)
            page.id = name
            
            do {
                let data = try await loadItems(from: url)
                fileManager.saveImage(data: data, name: name, chapter: chapter.id, manga: manga.id)
            } catch {
                basicHandleError(error)
            }
            
            newChapter.addToPages(page)
            index += 1
        }
        
        do {
            let coreManga = try await fetchManga()
            newChapter.manga = coreManga
        } catch {
            let newManga = MangaEntity(context: manager.context)
            newManga.translateMangaModel(model: manga)
            newChapter.manga = newManga
        }
        
        do {
            try await manager.save2()
        } catch {
            self.isLoading = false
            basicHandleError(error)
        }
        
        
    }
    
    func checkIfDownloaded() async {
        let request = NSFetchRequest<ChapterEntity>(entityName: "ChapterEntity")
        
        let filter = NSPredicate(format: "id == %@", chapter.id)
        request.predicate = filter
        
        do {
            try await manager.context.perform {
                let result = try request.execute()
                if !result.isEmpty {
                    self.isDownloaded = true
                }
            }
        } catch {
            basicHandleError(error)
        }
        

    }
    
    func fetchManga() async throws -> MangaEntity {
        let request = NSFetchRequest<MangaEntity>(entityName: "MangaEntity")
        request.fetchLimit = 1
        
        guard let manga = manga else { throw MangaDokushaError.noMangaFound}
        
        let filter = NSPredicate(format: "id == %@", manga.id)
        request.predicate = filter
        
        return try await manager.context.perform {
            let result = try request.execute().first
            if let res = result{
                return res
            } else {
                throw MangaDokushaError.noMangaFound
            }
            
        }
    }
    
}
