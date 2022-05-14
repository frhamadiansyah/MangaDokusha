//
//  Extension+View.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 12/04/22.
//

import Foundation
import SwiftUI
import CoreData

extension View {
    
    func handleError(error: MangaDokushaError?, showError: Binding<Bool>, completion: @escaping () -> Void) -> some View {
        modifier(ErrorHandle(showError: showError, error: error, completion: completion))
    }
    
    func isLoading(_ isLoading: Binding<Bool>) -> some View {
        modifier(LoadingHandle(isLoading: isLoading))
    }
    
    
}

extension ChapterEntity {
    
    func translateChapterModel(model: ChapterModel) {
        self.id = model.id
        self.chapter = model.chapter
        self.chapterTitle = model.title
        
    }
}


extension MangaEntity {
    
    func translateMangaModel(model: MangaModel) {
        self.id = model.id
        self.title = model.title
        guard let coverUrl = model.cover?.coverUrl else {return}
        self.coverUrl = coverUrl
        
    }
}
