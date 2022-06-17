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

extension UIImage {
    func isLandscape() -> Bool {
        if self.size.width > self.size.height {
            return true
        } else {
            return false
        }
    }
}

extension Float {
    func toString() -> String {
        if self.rounded(.up) == self.rounded(.down) {
            return String(format: "%.0f", self)
        } else {
            return String(format: "%.2f", self)
        }
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
    
    func translateToModel() -> MangaModel {
        let model = MangaModel(id: self.id ?? "No Id",
                               title: self.title ?? "No Title",
                               description: "No Description")
        print(model)
        return model
    }
}
