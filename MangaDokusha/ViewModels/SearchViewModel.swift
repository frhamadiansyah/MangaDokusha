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
    private var limit = 10
    
    init() {
        
    }
    
    func searchManga() {
        mangaList = []
        offset = 0
        
        listMangaService.getSearchMangaList(title: searchKeyword, limit: limit, offset: offset)
            .sink(receiveCompletion: { error in
                switch error {
                case .failure(let err):
                    print("___>>>>>")
                    print(err)
                    self.error = err as? MangaDokushaError
                    self.showError.toggle()
                case .finished:
                    print("finished")
                }
            }, receiveValue: { response in
                print("GET UEY")
                self.mangaList.append(contentsOf: response.data)
            })
            .store(in: &cancel)
        
    }
    
    func searchMoreIfNeeded(currentManga: MangaDetailModel?) {
        guard let item = currentManga else {
            searchManga()
            return
        }
        
        let thresholdIndex = mangaList.index(mangaList.endIndex, offsetBy: -5)
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
        
        listMangaService.getSearchMangaList(title: searchKeyword, limit: limit, offset: offset)
            .sink(receiveCompletion: { error in
                switch error {
                case .failure(let err):
                    print("___>>>>>")
                    print(err)
                    self.error = err as? MangaDokushaError
                    self.showError.toggle()
                case .finished:
                    print("finished")
                }
            }, receiveValue: { response in
                print("GET UEY")
                self.mangaList.append(contentsOf: response.data)
            })
            .store(in: &cancel)
    }
}
