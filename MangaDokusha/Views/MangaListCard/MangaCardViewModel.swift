//
//  MangaCardViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 13/05/22.
//

import Foundation

class MangaCardViewModel: BaseViewModel {
    
    @Published var coverUrl: String?
    
    @Published var title: String?
    
    @Published var count: Int = 0
    
    var manga: MangaModel?
    
    var entity: MangaEntity? 
    
    init(manga: MangaModel?) {
        self.manga = manga
        coverUrl = manga?.cover?.coverUrl
        title = manga?.title
    }
    
    init(entity: MangaEntity?) {
        self.entity = entity
        coverUrl = entity?.coverUrl
        title = entity?.title
        count = entity?.chapters?.count ?? 0
    }
}
