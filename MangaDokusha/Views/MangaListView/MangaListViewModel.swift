//
//  MangaListViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 19/04/22.
//

import Foundation
import Combine
import UIKit

class MangaListViewModel: BaseViewModel {
    @Published var mangaList: [MangaModel] = [] 
    
    var mangaListService = ListMangaService(apiService: APIService.shared)
    
    @Published var isLoading: Bool = false
    
    @Published var searchKeyword: String = ""
    @Published var currentRequest: URLRequest?
    
    private var offset = 0
    private var limit = 10
    
    override init() {
        super.init()
        isLoading = true
        newSearchManga()
    }
    
    init(creator: CreatorModel) {
        super.init()
        let request = getAuthorOrArtist(creator.id)
        getMangaList(request: request)
    }
    
    init(model: MangaModel, isArtist: Bool) {
        super.init()
        if isArtist {
            if let id = model.artist?.id {
                let request = getAuthorOrArtist(id)
                getMangaList(request: request)
            } else {
                error = .noMangaFound
                showError.toggle()
            }
        } else {
            if let id = model.author?.id {
                let request = getAuthorOrArtist(id)
                getMangaList(request: request)
            } else {
                error = .noMangaFound
                showError.toggle()
            }
        }
    }
    
    func getMangaListRequest(id: [String]) -> URLRequest {
        return mangaListService.generateListMangaRequest(mangaIds: id)
    }
    
    func getAuthorOrArtist(_ id: String) -> URLRequest {
        return mangaListService.generateListMangaRequestByArtist(artistIds: [id])
    }
    
    
    
    func newSearchManga() {
        $searchKeyword
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .removeDuplicates()
            .map({ (string) -> String in
                return string
            })
            .sink { result in
                self.resetParameter()
                if result.isEmpty {
                    let req = self.getMangaListRequest(id: mangaIds)
                    self.currentRequest = req
                    self.getMangaList(request: req)
                } else {
                    self.searchManga()
                }

            }
            .store(in: &cancel)
    }
    
    func getMangaList(request: URLRequest) {
        mangaListService.getListManga(request: request)
            .sink { error in
                self.basicHandleCompletionError(error: error)
            } receiveValue: { models in
                self.isLoading = false
                if models.isEmpty {
                    self.error = .noMangaFound
                    self.showError.toggle()
                } else {
                    self.mangaList.append(contentsOf: models)
                    print(self.mangaList.count)
                }
            }.store(in: &cancel)
    }
    
    func resetParameter() {
        mangaList = []
        offset = 0
    }
    
    func searchManga() {
    
        isLoading = true
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

