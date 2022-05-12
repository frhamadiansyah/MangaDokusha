//
//  MangaDexRelationshipType.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 30/04/22.
//

import Foundation
import SwiftUI

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
    
    func getColor() -> Color {
        switch self {
        case .safeContent:
            return Color.green
        case .suggestive:
            return Color.orange
        case .erotica:
            return Color.pink
        case .pornographic:
            return Color.red
        case .unknown:
            return Color.gray
        }
    }
}

enum MangaStatus: String {
    case ongoing = "ongoing"
    case completed = "completed"
    case hiatus = "hiatus"
    case cancelled = "cancelled"
    case unknown
    
    func getColor() -> Color {
        switch self {
        case .ongoing:
            return Color.green
        case .completed:
            return Color.blue
        case .hiatus:
            return Color.orange
        case .cancelled:
            return Color.red
        case .unknown:
            return Color.gray
        }
    }
}

enum PublicationDemographic: String {
    case shounen = "shounen"
    case shoujo = "shoujo"
    case josei = "josei"
    case seinen = "seinen"
    case unknown
}
