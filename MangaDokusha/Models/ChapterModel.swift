//
//  ChapterModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 04/05/22.
//

import Foundation

struct ChapterModel: Identifiable {
    let id: String
    var chapter: String = ""
    var title: String = "No Title"
    var group: String = "Unknown"
    
    var manga: MangaModel?
    
    init(_ response: MangaDexData) {
        id = response.id
        
        guard case .chapter(let chap) = response.attributes else {
            return
        }
        chapter = chap.chapter
        title = chap.title ?? "no title"
        
        guard let relationships = response.relationships else { return }
        
        for relationship in relationships where relationship.type != .unknownType {
            if relationship.type == .manga {
                manga = MangaModel(relationship)
            } else if relationship.type == .scanlation {
                guard case .creator(let creator) = relationship.attributes else { return }
                group = creator.name
            }
        }
    }
    
    init() {
        id = ""
    }
    
}
