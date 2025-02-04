//
//  ReadChapterViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 08/04/22.
//

import Foundation
import Combine

class ReadChapterViewModel: BaseViewModel {
    var manga: MangaModel?
    var currentChapter: ChapterModel?
    
    var readChapterService = ReadChapterService(apiService: APIService())
    
    @Published var imageUrls = [String]()

    override init() {
        super.init()
    }
    
    init(manga: MangaModel?, chapter: ChapterModel?) {
        self.manga = manga
        self.currentChapter = chapter
    }
    
    func getChapterImageRequest() -> URLRequest {
        return readChapterService.getReadChapterRequest(chapterId: currentChapter?.id ?? "")
    }
    
    func loadChapterImageUrl(request: URLRequest) {
        imageUrls = []
        readChapterService.getChapterImageModel(request: request)
            .sink { error in
                self.basicHandleCompletionError(error: error)
            } receiveValue: { model in
                self.imageUrls.append(contentsOf: model.saverImageUrls)
            }.store(in: &cancel)
    }
}

