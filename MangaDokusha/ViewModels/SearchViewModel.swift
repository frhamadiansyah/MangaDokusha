//
//  SearchViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 13/04/22.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var error: MangaDokushaError?
    @Published var showError: Bool = false
    
    @Published var mangaList: [MangaDetailModel] = []
    
    @Published var searchKeyword: String = ""
    @Published var isLoading: Bool = false
    
    let listMangaService = ListMangaService(apiService: APIService())
    
    var cancel = Set<AnyCancellable>()
    
    private var offset = 0
    private var limit = 50
    
    var currentRequest: URLRequest?
    
    init() {
        
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
                if !response.data.isEmpty {
                    self.mangaList.append(contentsOf: response.data)
                } else {
                    self.error = .noMangaFound
                    self.showError.toggle()
                    self.searchKeyword = ""
                }
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
    
    func searchMoreIfNeeded(currentManga: MangaDetailModel?) {
        guard let item = currentManga else {
            searchManga()
            return
        }
        
        let thresholdIndex = mangaList.index(mangaList.endIndex, offsetBy: -2)
            if mangaList.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
              loadMoreManga()
            }
    }
    
    func loadMoreManga() {
        guard !isLoading else {
          return
        }

        offset += limit
        isLoading = true
        currentRequest = listMangaService.searchMangaRequest(title: searchKeyword, limit: limit, offset: offset)
        
        guard let request = currentRequest else { return }
        
        getMangaList(request: request)
    }
}
