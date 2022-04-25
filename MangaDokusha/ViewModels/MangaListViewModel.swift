//
//  MangaListViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 19/04/22.
//

import Foundation
import Combine

class MangaListViewModel: ObservableObject {
    @Published var error: MangaDokushaError?
    @Published var showError: Bool = false
    
    @Published var mangaList: [MangaDetailModel] = []
    
    let listMangaService = ListMangaService(apiService: APIService())
    
    var cancel = Set<AnyCancellable>()
    
    @Published var currentRequest: URLRequest?
    
    @Published var searchKeyword: String = ""
    @Published var isLoading: Bool = false
    
    private var offset = 0
    private var limit = 50
    
    var authorId: String?
    var artistId: String?
    
    init() {
        
    }
    
    init(mangaIds: [String]) {
        listMangaService.getMangaList(mangaIds: mangaIds)
            .sink(receiveCompletion: { error in
                switch error {
                case .failure(let err):
                    self.error = err as? MangaDokushaError
                    self.showError.toggle()
                case .finished:
                    print("finished")
                }
            }, receiveValue: { response in
                self.mangaList.append(contentsOf: response.data)
            })
            .store(in: &cancel)
    }
    
    init(authorId: String) {
        currentRequest = listMangaService.generateListMangaRequestByAuthor(authorIds: [authorId])

    }
    
    init(artistId: String) {
        currentRequest = listMangaService.generateListMangaRequestByArtist(artistIds: [artistId])

    }
    
    func getMangaList(request: URLRequest) {
        listMangaService.getMangaList(request: request)
            .sink(receiveCompletion: { error in
                switch error {
                case .failure(let err):
                    self.error = err as? MangaDokushaError
                    self.showError.toggle()
                case .finished:
                    print("finished")
                }
            }, receiveValue: { response in
                self.mangaList.append(contentsOf: response.data)
            })
            .store(in: &cancel)
    }
    
    
    func searchManga() {
        mangaList = []
        offset = 0
        
        currentRequest = listMangaService.searchMangaRequest(title: searchKeyword, limit: limit, offset: offset)
        
        guard let request = currentRequest else { return }
        
        getMangaList(request: request)
        
    }
    
    func fetchMoreIfNeeded(currentManga: MangaDetailModel?) {
        guard let item = currentManga else {
            searchManga()
            return
        }
        
        let thresholdIndex = mangaList.index(mangaList.endIndex, offsetBy: -5)
            if mangaList.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
              searchMoreManga()
            }
    }
    
    func searchMoreManga() {
        guard !isLoading else {
          return
        }

        offset += limit
        isLoading = true
        currentRequest = listMangaService.searchMangaRequest(title: searchKeyword, limit: limit, offset: offset)
        
        guard let request = currentRequest else { return }
        
        getMangaList(request: request)
    }
    
    func getAuthorManga(authorId: String) {
        mangaList = []
        offset = 0
        
        currentRequest = listMangaService.generateListMangaRequestByAuthor(authorIds: [authorId])
        
        guard let request = currentRequest else { return }
        getMangaList(request: request)
    }
    
    func getArtistManga(artistId: String) {
        mangaList = []
        offset = 0
        
        currentRequest = listMangaService.generateListMangaRequestByArtist(artistIds: [artistId])
        
        guard let request = currentRequest else { return }
        getMangaList(request: request)
    }
}
