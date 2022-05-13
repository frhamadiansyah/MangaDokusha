//
//  ChapterViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 13/05/22.
//

import Foundation
import CoreData

class ChapterViewModel: BaseViewModel {
    
    let manager = CoreDataManager.instance
    
    var manga: MangaModel?
    
    var chapter: ChapterModel
    
    init(manga: MangaModel?, chapter: ChapterModel) {
        self.manga = manga
        self.chapter = chapter
    }
    
    
    func addChapter() {
        let newChapter = ChapterEntity(context: manager.context)
        
        newChapter.id = chapter.id
        newChapter.chapter = chapter.chapter
        
        if let manga = manga {
            let newManga = MangaEntity(context: manager.context)
            newManga.id = manga.id
            newManga.title = manga.title
            newChapter.manga = newManga
        }
        
        manager.save()
    }
    
}
