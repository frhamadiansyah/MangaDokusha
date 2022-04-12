//
//  MangaCoverResponse.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 07/04/22.
//

import Foundation


struct MangaCoverModel: Decodable {
    let mangaId: String
    let coverId: String
    let fileName: String
    let mangaCoverUrl: String
    
    init(from decoder: Decoder) throws {
        let rawResponse = try RawMangaCoverModel(from: decoder)
        
        coverId = rawResponse.data.id
        fileName = rawResponse.data.attributes.fileName
        
        var manga = ""
        for item in rawResponse.data.relationships {
            if item.type == "manga" {
                manga = item.id
            }
        }
        mangaId = manga
        
        mangaCoverUrl = "\(imageBaseUrl)/covers/\(mangaId)/\(fileName)"
    }
    
}

fileprivate struct RawMangaCoverModel: Decodable {
    struct RawMangaData: Decodable {
        let id: String
        let attributes: RawMangaAttributes
        let relationships: [RawMangaRelationship]
    }
    
    struct RawMangaAttributes: Decodable {
        let fileName: String
    }
    
    struct RawMangaRelationship: Decodable {
        let id: String
        let type: String
    }
    
    let data: RawMangaData
}
