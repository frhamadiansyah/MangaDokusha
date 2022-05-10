//
//  MangaListViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 19/04/22.
//

import Foundation
import Combine

class MangaListViewModel: BaseViewModel {
    @Published var mangaList: [MangaModel] = [] 
    
    var mangaListService = ListMangaService(apiService: APIService.shared)
    
    @Published var isLoading: Bool = false
    
    @Published var searchKeyword: String = ""
    @Published var currentRequest: URLRequest? {
        didSet {
            if let req = currentRequest {
                getMangaList(request: req)
            }
        }
    }
    
    private var offset = 0
    private var limit = 50
    
    override init() {
        super.init()
    }
    
    func getMangaListRequest(id: [String]) -> URLRequest {
        return mangaListService.generateListMangaRequest(mangaIds: id)
    }
    
    
    func getMangaList(request: URLRequest) {
        mangaListService.getListManga(request: request)
            .sink { error in
                self.basicHandleCompletionError(error: error)
            } receiveValue: { models in
                self.mangaList.append(contentsOf: models)
            }.store(in: &cancel)
    }
    
    func searchManga() {
        mangaList = []
        offset = 0
    
        currentRequest = mangaListService.searchMangaRequest(title: searchKeyword, limit: limit, offset: offset)
    
        guard let request = currentRequest else { return }
    
        getMangaList(request: request)
    
    }
    
    func searchMoreManga() {
        guard !isLoading else {
            return
        }
    
        offset += limit
        isLoading = true
        currentRequest = mangaListService.searchMangaRequest(title: searchKeyword, limit: limit, offset: offset)
    
        guard let request = currentRequest else { return }
    
        getMangaList(request: request)
    }
    
    func searchMoreIfNeeded(currentManga: MangaModel?) {
        guard let item = currentManga else {
            searchManga()
            return
        }

        let thresholdIndex = mangaList.index(mangaList.endIndex, offsetBy: -5)
            if mangaList.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
                searchMoreManga()
            }
    }
    
    
}

