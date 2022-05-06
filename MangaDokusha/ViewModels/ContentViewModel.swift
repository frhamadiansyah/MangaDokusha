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

//class ContentViewModel: ObservableObject {
//
//    let detailService: MangaDetailService = MangaDetailService(apiService: APIService())
//    let listChapterService: ListChapterService = ListChapterService(apiService: APIService())
//
//    @Published var mangaDetail: MangaDetailModel?
//
//    var cancel = Set<AnyCancellable>()
//
//    @Published var showError: Bool = false
//    @Published var error: MangaDokushaError?
//
//
//    let mangaId: String
//
//
//    init(mangaId: String) {
//
//        self.mangaId = mangaId
//
//    }
//
//    func getDetailManga(mangaId: String) {
//        detailService.getMangaDetail(mangaId: mangaId).sink { [unowned self] error in
//            switch error {
//            case .failure(let err):
//                self.error = err as? MangaDokushaError
//                self.showError.toggle()
//            case .finished:
//                print("finished")
//            }
//        } receiveValue: { [weak self] data in
//
//            self?.mangaDetail = data.data
//        }.store(in: &cancel)
//    }
//
//
//}
