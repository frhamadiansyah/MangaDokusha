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
    
    var mangaId: String
    
    init(mangaId: String) {
        self.mangaId = mangaId
    }
    
    
    func getDetailMangaRequest(mangaId: String) -> URLRequest {
        return mangaService.getMangaRequest(mangaId: mangaId)
    }
    
    func getDetailManga(urlRequest: URLRequest) {
        mangaService.getManga(request: urlRequest)
            .sink { error in
                self.basicHandleCompletionError(error: error)
            } receiveValue: { model in
                self.mangaModel = model
            }.store(in: &cancel)
    }
    
}

