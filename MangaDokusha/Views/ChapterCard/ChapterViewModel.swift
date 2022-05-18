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
    
    func loadChapterImageUrl(request: URLRequest, completion: @escaping ([String], [String]) -> Void) {
        imageUrls = []
        readChapterService.getChapterImageModel(request: request)
            .sink { error in
                self.basicHandleCompletionError(error: error)
                completion([], [])
            } receiveValue: { model in
                self.imageUrls.append(contentsOf: model.saverImageUrls)
                self.fileNames.append(contentsOf: model.saverFileName)
                completion(model.saverImageUrls, model.saverFileName)
            }.store(in: &cancel)
    }
    
    
    func loadItems(from urlString: String) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: URL(string: urlString)!)
        return data
    }
    

    @MainActor
    func downloadChapter() {
        isLoading = true
        let request = getChapterImageRequest()
        loadChapterImageUrl(request: request) { array, filename  in
            if array.count > 0 {
                Task {
                    await self.addChapterr(pageUrls: array, fileName: filename)
                    self.isLoading = false
                    self.isDownloaded = true
                }
            }
        }
    }

    
    @MainActor
    func addChapterr(pageUrls: [String], fileName: [String]) async {
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
                fileManager.saveImage(data: data, name: name)
            } catch {
                print("GAGAL")
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
