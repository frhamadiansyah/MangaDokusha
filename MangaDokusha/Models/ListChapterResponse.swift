//
//  ListChapterResponse.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 08/04/22.
//

import Foundation

struct ListChapterModel: Decodable {
    let data: [ChapterTitleModel]
    let limit: Int
    let offset: Int
    let total: Int
}

struct ChapterTitleModel: Decodable, Identifiable {
    let id: String
    var mangaId: String
    var mangaTitle: String
    var scanlation: String
    let chapter: String
    let chapterTitle: String
    let createdAt: String
    
    init(from decoder: Decoder) throws {
        let rawResponse = try RawChapterTitleModel(from: decoder)
        
        id = rawResponse.id
        chapter = rawResponse.attributes.chapter
        chapterTitle = rawResponse.attributes.title ?? "no title"
        
        let time = rawResponse.attributes.createdAt.components(separatedBy: "+")
        createdAt = time[0]
        
        mangaId = ""
        mangaTitle = "No English Title"
        scanlation = "No Group"
        for item in rawResponse.relationships {
            if item.type == "manga" {
                mangaId = item.id
                if let titleEn = item.attributes?.title?.en{
                    mangaTitle = titleEn
                }

            } else if item.type == "scanlation_group" {
                if let scan = item.attributes?.name {
                    scanlation = scan
                }

            }
        }
    }
    
    init(id: String, mangaId: String, mangaTitle: String, scanlation: String, chapter: String, chapterTitle: String) {
        self.id = id
        self.mangaId = mangaId
        self.mangaTitle = mangaTitle
        self.scanlation = scanlation
        self.chapter = chapter
        self.chapterTitle = chapterTitle
        self.createdAt = ""
    }
}

fileprivate struct RawChapterTitleModel: Decodable {

    struct RawChaptersAttributes: Decodable {
        let chapter: String
        let title: String?
        let createdAt: String
    }
    
    struct RawChaptersRelationships: Decodable {
        let id: String
        let type: String
        let attributes: RawExpandedAttributes?
    }
    
    
    struct RawExpandedAttributes: Decodable {
        let name: String?
        let title: RawMultiLanguageText?
    }
    
    struct RawMultiLanguageText: Decodable {
        let en: String?
        let jp: String?
    }
    
    let id: String
    let attributes: RawChaptersAttributes
    let relationships: [RawChaptersRelationships]
}
