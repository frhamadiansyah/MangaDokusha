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
    var artistId: String?
    var artist: String?
    var authorId: String?
    var author: String?
    var coverId: String?
    var coverFileName: String?
    var coverUrl: String?
    let contentRating: ContentRating
    let status: String
    
    init(from decoder: Decoder) throws {
        let rawResponse = try RawMangaDetailModel(from: decoder)
        
        id = rawResponse.id
        let titleEn = rawResponse.attributes.title.en
        title = titleEn ?? "No English Title"
        contentRating = ContentRating.init(rawValue: rawResponse.attributes.contentRating) ?? .safeContent
        description = rawResponse.attributes.description?.en ?? "No English Description"
        status = rawResponse.attributes.status
        guard let relationship = rawResponse.relationships else { return }
        for item in relationship {
            
            if item.type == "cover_art" {
                coverId = item.id
                coverFileName = item.attributes?.fileName
                if let fileName = coverFileName {
                    coverUrl = "\(imageBaseUrl)/covers/\(id)/\(fileName)"
                }
            } else if item.type == "artist" {
                artistId = item.id
                artist = item.attributes?.name
            } else if item.type == "author" {
                authorId = item.id
                author = item.attributes?.name
            }
        }
    }
    
    init(id: String, title: String, description: String, coverId: String?, contentRating: ContentRating = .safeContent) {
        self.id = id
        self.title = title
        self.description = description
        self.coverId = coverId
        self.contentRating = contentRating
        self.status = ""
    }
    
}

struct MangaDetailResponse: Decodable {
    let result: String
    let response: String
    let data: MangaDetailModel
    
}

struct ListMangaDetailResponse: Decodable {
    let result: String
    let response: String
    let data: [MangaDetailModel]
    
}

fileprivate struct RawMangaDetailModel: Decodable {

    struct RawMangaAttributes: Decodable {
        let title: MultiLanguageText
        let description: MultiLanguageText?
        let contentRating: String
        let status: String
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
    
    struct MultiLanguageText: Decodable {
        let en: String?
        let jp: String?
        
        init(from decoder: Decoder) throws {
            do {
                let result = try RawMultiLanguageText(from: decoder)
                en = result.en
                jp = result.jp
            } catch {
                en = "NO VALUE"
                jp = "NO VALUE"
            }
        }
    }

    let id: String
    var attributes: RawMangaAttributes
    let relationships: [RawMangaRelationship]?

}

