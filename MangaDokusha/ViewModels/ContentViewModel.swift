//
//  ContentViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 06/04/22.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    
    let detailService: MangaDetailService = MangaDetailService(apiService: APIService())
    let listChapterService: ListChapterService = ListChapterService(apiService: APIService())
    
    @Published var mangaDetail: MangaDetailModel? {
        didSet {
            print(mangaDetail)
        }
    }
    
    var cancel = Set<AnyCancellable>()
    
    @Published var showError: Bool = false
    @Published var error: MangaDokushaError?

    
    let mangaId: String
    
    
    init(mangaId: String) {

        self.mangaId = mangaId

    }
    
    func getDetailManga(mangaId: String) {
        detailService.getMangaDetail(mangaId: mangaId).sink { [unowned self] error in
            switch error {
            case .failure(let err):
                print("___>>>>>")
                print(err)
                self.error = err as? MangaDokushaError
                self.showError.toggle()
            case .finished:
                print("finished")
            }
        } receiveValue: { [weak self] data in

            self?.mangaDetail = data
            print("GET")
            print(data)
        }.store(in: &cancel)
    }
    
    
}
