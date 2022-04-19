//
//  HomeViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 12/04/22.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var error: MangaDokushaError?
    @Published var showError: Bool = false
    
    @Published var mangaList: [MangaDetailModel] = []
    
    let listMangaService = ListMangaService(apiService: APIService())
    
    var cancel = Set<AnyCancellable>()
    
    init() {
        listMangaService.getMangaList(mangaIds: mangaIds)
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
