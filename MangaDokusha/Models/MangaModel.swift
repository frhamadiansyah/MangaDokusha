//
//  MangaModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 01/05/22.
//

import Foundation


struct MangaModel: Identifiable {
    var id: String = ""
    var title: String = ""
    var description: String = ""
    var artist: CreatorModel? = nil
    var author: CreatorModel? = nil
    var cover: CoverModel? = nil
    var status: MangaStatus = .unknown
    var contentRating: ContentRating = .unknown
    var publicationDemographic: PublicationDemographic = .unknown
    var tags: [String] = []
    
    init(_ response: MangaDexData) {
        id = response.id
        
        guard case .manga(let manga) = response.attributes else {
            return
        }
        title = manga.title.en ?? "No Title"
        description = manga.description.en ?? "No Description"
        status = manga.status
        contentRating = manga.contentRating
        publicationDemographic = manga.publicationDemographic
        let newTags: [String?] = manga.tags.map({ data -> String? in
            guard case .tag(let tag) = data.attributes else {return nil}
            if let res = tag.name.en {
                return res
            } else {
                return nil
            }
        })
        
        tags = newTags.compactMap({$0})
        
        guard let relationships = response.relationships else { return }
        
        for relationship in relationships where relationship.type != .unknownType {
            if relationship.type == .artist {
                artist = CreatorModel(relationship)
            } else if relationship.type == .author {
                author = CreatorModel(relationship)
            } else if relationship.type == .cover {
                cover = CoverModel(relationship)
                cover?.updateCoverUrl(mangaId: id)
            }
            
            
        }

    }
    
    init(_ response: ChildMangaDexData) {
        id = response.id
        
        guard case .manga(let manga) = response.attributes else {
            return
        }
        title = manga.title.en ?? "No Title"
        description = manga.description.en ?? "No Description"
        status = manga.status
        contentRating = manga.contentRating
        publicationDemographic = manga.publicationDemographic
        let newTags: [String?] = manga.tags.map({ data -> String? in
            guard case .tag(let tag) = data.attributes else {return nil}
            if let res = tag.name.en {
                return res
            } else {
                return nil
            }
        })
        
        tags = newTags.compactMap({$0})

    }
    
    init(id: String = "", title: String = "", description: String = "") {
        self.id = id
        self.title = title
        self.description = description
    }
    
    init() {
        
    }

}

struct CoverModel: Identifiable {
    let id: String
    var fileName: String = ""
    var coverUrl: String = ""
    
    init(_ response: ChildMangaDexData) {
        id = response.id
        
        guard case .cover(let cover) = response.attributes else {
            return
        }
        fileName = cover.fileName
        coverUrl = "\(imageBaseUrl)/covers/\(id)/\(fileName)"
    }
    
    mutating func updateCoverUrl(mangaId: String) {
        coverUrl = "\(imageBaseUrl)/covers/\(mangaId)/\(fileName).256.jpg"
    }
}

struct CreatorModel: Identifiable {
    let id: String
    var name: String = "Unnamed"
    
    init(_ response: ChildMangaDexData) {
        id = response.id
        
        guard case .creator(let creator) = response.attributes else { return }
        
        name = creator.name
    }
}
