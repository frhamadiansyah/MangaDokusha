//
//  ListChapterViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 08/04/22.
//

import Foundation
import Combine

//enum ChapterError: Error {
//    case decodingError
//    case noChapter
//    case networkError(Error)
//}

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

//class ListChapterViewModel: ObservableObject {
//    
//    let mangaDetail: MangaDetailModel
//    
//    let listChapterService = ListChapterService(apiService: APIService())
//    
//    @Published var listChapter: [ChapterTitleModel] = []
//    @Published var isLoading: Bool = false
//    @Published var isAscending: Bool = true
//    
//    var cancel = Set<AnyCancellable>()
//    
//    @Published var error: MangaDokushaError?
//    @Published var showError: Bool = false
//    
//    private var offset = 0
//    private var limit = 50
//    
//    init(mangaDetail: MangaDetailModel) {
//        self.mangaDetail = mangaDetail
//        
////        loadInitialChapterList()
//        
//    }
//    
//    func loadInitialChapterList() {
//        listChapter = []
//        offset = 0
//        
//        getListChapter(mangaId: mangaDetail.id, limit: limit, offset: 0, ascending: isAscending)
//    }
//    
//    func loadMoreIfNeeded(currentChapter: ChapterTitleModel?) {
//        guard let item = currentChapter else {
//            loadInitialChapterList()
//            return
//        }
//
//        let thresholdIndex = listChapter.index(listChapter.endIndex, offsetBy: -5)
//            if listChapter.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
//              loadMoreChapter()
//            }
//    }
//
//    func loadMoreChapter() {
//        guard !isLoading else {
//          return
//        }
//
//        offset += limit
//        isLoading = true
//
//        listChapterService.getListChapter(mangaId: mangaDetail.id, offset: offset).sink { error in
//            switch error {
//            case .failure(let err):
//                print("___>>>>>")
//                print(err)
//                self.error = err as? MangaDokushaError
//                self.showError.toggle()
//            case .finished:
//                print("finished")
//            }
//        } receiveValue: {[unowned self] mod in
//            self.listChapter.append(contentsOf: mod.data)
//            print(mod)
//            print(offset)
//            self.isLoading = false
//        }.store(in: &cancel)
//
//    }
//    
//    func getListChapter(mangaId: String, limit: Int, offset: Int, ascending: Bool) {
//        listChapterService.getListChapter(mangaId: mangaId, limit: limit, offset: offset, ascending: ascending).sink { error in
//            switch error {
//            case .failure(let err):
//                print("___>>>>>")
//                print(err)
//                self.error = err as? MangaDokushaError
//                self.showError.toggle()
//            case .finished:
//                print("finished")
//            }
//        } receiveValue: { [unowned self] mod in
//            self.listChapter.append(contentsOf: mod.data)
//            print(mod)
//            self.isLoading = false
//        }.store(in: &cancel)
//
//    }
//}
