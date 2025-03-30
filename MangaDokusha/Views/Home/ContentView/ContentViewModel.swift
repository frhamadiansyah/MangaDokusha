//
//  ContentViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 06/04/22.
//

import Foundation
import Combine

class ContentViewModel: BaseViewModel {
    var mangaService: MangaService = MangaService(apiService: APIService.shared)
    
    @Published var mangaModel: MangaModel?
    @Published var isFavorite: Bool = false
    
    var mangaId: String
    
    init(mangaId: String) {
        self.mangaId = mangaId
    }
    
    init(manga: MangaModel) {
        self.mangaId = manga.id
        mangaModel = manga
    }
    
    
    func getDetailMangaRequest(mangaId: String) -> URLRequest {
        return mangaService.getMangaRequest(mangaId: mangaId)
    }
    
    func getDetailManga(urlRequest: URLRequest) {
        mangaService.getManga(request: urlRequest)
            .sink { [weak self] error in
                self?.basicHandleCompletionError(error: error)
            } receiveValue: { [weak self] model in
                self?.mangaModel = model
            }.store(in: &cancel)
    }
    
    func checkIfFavorite() {
        let listFavoriteManga = UserDefaults.standard.array(forKey: "favorites") as? [String] ?? []
        if !listFavoriteManga.filter({$0 == mangaId}).isEmpty {
            isFavorite = true
        } else {
            isFavorite = false
        }
    }
    
    func toggleFavorite() {
        var listFavoriteManga = UserDefaults.standard.array(forKey: "favorites") as? [String] ?? []
        if !listFavoriteManga.filter({$0 == mangaId}).isEmpty {
            UserDefaults.standard.set(listFavoriteManga.filter({$0 != mangaId}), forKey: "favorites")
            isFavorite = false
        } else {
            listFavoriteManga.append(mangaId)
            UserDefaults.standard.set(listFavoriteManga, forKey: "favorites")
            isFavorite = true
        }
        
        
    }
    
}

