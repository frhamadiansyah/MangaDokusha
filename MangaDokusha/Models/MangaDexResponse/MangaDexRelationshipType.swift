//
//  MangaDexRelationshipType.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 30/04/22.
//

import Foundation

enum MangaDexRelationshipType: String {
    case manga = "manga"
    case chapter = "chapter"
    case artist = "artist"
    case author = "author"
    case cover = "cover_art"
    case scanlation = "scanlation_group"
    case unknownType = "unknownType"
}

//MARK: - Manga Enum
enum ContentRating: String {
    case safeContent = "safe"
    case suggestive = "suggestive"
    case erotica = "erotica"
    case pornographic = "pornographic"
    case unknown
}

enum MangaStatus: String {
    case ongoing = "ongoing"
    case completed = "completed"
    case hiatus = "hiatus"
    case cancelled = "cancelled"
    case unknown
}
