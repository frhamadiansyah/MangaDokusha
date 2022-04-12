//
//  ReadChapterViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 08/04/22.
//

import Foundation
import Combine

class ReadChapterViewModel: ObservableObject {
    var chapterId: String
    var mangaId: String
    var mangaDetail: MangaDetailModel
    let readChapterService = ReadChapterService(apiService: APIService())
    let listChapterService = ListChapterService(apiService: APIService())
    
    @Published var imageUrl: [String] = []
    
    var cancel = Set<AnyCancellable>()
    
    @Published var currentChapter: ChapterTitleModel
    @Published var error: MangaDokushaError?
    @Published var showError: Bool = false

    
    init(chapter: ChapterTitleModel, mangaDetail: MangaDetailModel) {
        self.mangaDetail = mangaDetail
        self.currentChapter = chapter
        self.chapterId = chapter.id
        self.mangaId = chapter.mangaId
        
    }
    
    func loadChapterImageUrl(chapterId: String) {
        readChapterService.getChapterImage(chapterId: chapterId).sink { error in
            switch error {
            case .failure(let err):
                print("___>>>>>")
                print(err)
                self.error = err as? MangaDokushaError
                self.showError.toggle()
            case .finished:
                print("finished")
            }
        } receiveValue: { [unowned self] mod in
            self.imageUrl = []
            print(mod)
            self.imageUrl.append(contentsOf: mod.imageUrl)
        }.store(in: &cancel)

    }
    
    func nextChapter(chapter: ChapterTitleModel) {
        listChapterService.getNextOrPreviousChapter(mangaId: chapter.mangaId, currentChapter: chapter.chapter, createdAt: chapter.createdAt, nextChapter: true).sink { error  in
            switch error {
            case .failure(let err):
                print("___>>>>>")
                print(err)
                self.error = err as? MangaDokushaError
                self.showError.toggle()
            case .finished:
                print("finished")
            }
        } receiveValue: { [unowned self] mod in
            if !mod.data.isEmpty {
                let nextChapter = mod.data[1] // based on createdAt
                currentChapter = nextChapter
                chapterId = nextChapter.id
                mangaId = nextChapter.mangaId
                self.loadChapterImageUrl(chapterId: nextChapter.id)
            } else {
                error = .noChapter
                showError.toggle()
            }
        }.store(in: &cancel)
    }
    
    func previousChapter(chapter: ChapterTitleModel) {
        listChapterService.getNextOrPreviousChapter(mangaId: chapter.mangaId, currentChapter: chapter.chapter, createdAt: chapter.createdAt, nextChapter: false).sink { error  in
            switch error {
            case .failure(let err):
                print("___>>>>>")
                print(err)
                self.error = err as? MangaDokushaError
                self.showError.toggle()
            case .finished:
                print("finished")
            }
        } receiveValue: { [unowned self] mod in
            if !mod.data.isEmpty {
                let nextChapter = mod.data[0] // based on chapter number
                currentChapter = nextChapter
                chapterId = nextChapter.id
                mangaId = nextChapter.mangaId
                self.loadChapterImageUrl(chapterId: nextChapter.id)
            } else {
                error = .noChapter
                showError.toggle()
            }
        }.store(in: &cancel)
    }
    
    func goToNextChapter() {
        nextChapter(chapter: currentChapter)
    }
    
    func goToPrevioustChapter() {
        previousChapter(chapter: currentChapter)
    }
}
