//
//  ListChapterViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 08/04/22.
//

import Foundation
import Combine

class ListChapterViewModel: BaseViewModel {
    
    var currentManga: MangaModel?
    
    var listChapterService = ListChapterService(apiService: APIService())
    
    @Published var selectedChapter: ChapterModel? {
        didSet {
            readingVm.manga = currentManga
            readingVm.currentChapter = selectedChapter
        }
    }
    
    @Published var readingVm: ReadChapterViewModel = ReadChapterViewModel()
    
    @Published var listChapter: [ChapterModel] = []
    @Published var isLoading: Bool = false
    @Published var isAscending: Bool = true {
        didSet {
            loadInitialChapterList()
        }
    }
    
    var offset = 0
    var limit = 50
    
    init(manga: MangaModel) {
        currentManga = manga
    }
    
    func getChaptersRequest(id: String, limit: Int, offset: Int, ascending: Bool) -> URLRequest {
        return listChapterService.generateListChapterRequest(mangaId: id, limit: limit, offset: offset, ascending: ascending)
    }
    
    func loadInitialChapterList() {
        offset = 0
        listChapter = []
        
        guard let manga = currentManga else { return }
        
        let request = getChaptersRequest(id: manga.id, limit: limit, offset: offset, ascending: isAscending)
        
        listChapterService.getListChapter(request: request)
            .sink { error in
                self.basicHandleCompletionError(error: error)
            } receiveValue: { models in
                self.listChapter.append(contentsOf: models)
            }.store(in: &cancel)

    }
    
    func loadMoreIfNeeded(currentChapter: ChapterModel?) {
        guard let item = currentChapter else {
            loadInitialChapterList()
            return
        }
        
        let thresholdIndex = listChapter.index(listChapter.endIndex, offsetBy: -5)
            if listChapter.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
              loadMoreChapter()
            }
    }
    
    func loadMoreChapter() {
        guard !isLoading else {
          return
        }

        offset += limit
        isLoading = true
        
        guard let manga = currentManga else { return }
        let request = getChaptersRequest(id: manga.id, limit: limit, offset: offset, ascending: isAscending)
        listChapterService.getListChapter(request: request)
            .sink { error in
                self.basicHandleCompletionError(error: error)
            } receiveValue: { models in
                self.listChapter.append(contentsOf: models)
                self.isLoading = false
            }.store(in: &cancel)

    }
}

