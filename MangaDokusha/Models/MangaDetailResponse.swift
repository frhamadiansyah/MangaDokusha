//
//  MangaDetailResponse.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 06/04/22.
//

import Foundation

enum ContentRating: String {
    case safeContent = "safe"
    case suggestive = "suggestive"
    case erotica = "erotica"
    case pornographic = "pornographic"
}


struct MangaDetailModel: Decodable, Identifiable {
    let id: String
    let title: String
    let description: String
    var artist: String?
    var author: String?
    var coverId: String?
    var coverFileName: String?
    var coverUrl: String?
    let contentRating: ContentRating
    
    init(from decoder: Decoder) throws {
        let rawResponse = try RawMangaDetailModel(from: decoder)
        
        id = rawResponse.data.id
        let titleEn = rawResponse.data.attributes.title.en
        title = titleEn ?? "No English Title"
        contentRating = ContentRating.init(rawValue: rawResponse.data.attributes.contentRating) ?? .safeContent
        description = rawResponse.data.attributes.description.en ?? "No English Description"
        for item in rawResponse.data.relationships {
            
            if item.type == "cover_art" {
                coverId = item.id
                coverFileName = item.attributes?.fileName
                if let fileName = coverFileName {
                    coverUrl = "\(imageBaseUrl)/covers/\(id)/\(fileName)"
                }
            } else if item.type == "artist" {
                artist = item.attributes?.name
            } else if item.type == "author" {
                author = item.attributes?.name
            }
        }
    }
    
    init(id: String, title: String, description: String, coverId: String?, contentRating: ContentRating = .safeContent) {
        self.id = id
        self.title = title
        self.description = description
        self.coverId = coverId
        self.author = nil
        self.artist = nil
        self.coverFileName = nil
        self.coverUrl = nil
        self.contentRating = contentRating
    }
    
}

fileprivate struct RawMangaDetailModel: Decodable {
    struct RawMangaData: Decodable {
        let id: String
        var attributes: RawMangaAttributes
        let relationships: [RawMangaRelationship]
    }
    
    struct RawMangaAttributes: Decodable {
        let title: RawMultiLanguageText
        let description: RawMultiLanguageText
        let contentRating: String
    }
    
    struct RawMangaRelationship: Decodable {
        let id: String
        let type: String
        let attributes: RawExpandedAttributes?
    }
    
    struct RawExpandedAttributes: Decodable {
        let name: String?
        let fileName: String?

    }
    
    struct RawMultiLanguageText: Decodable {
        let en: String?
        let jp: String?
    }
    
    let data: RawMangaData
    
}

