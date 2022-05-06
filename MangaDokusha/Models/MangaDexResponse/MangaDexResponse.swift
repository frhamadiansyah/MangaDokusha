//
//  MangaDexResponse.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 29/04/22.
//

import Foundation


struct MangaDexResponse: Decodable {
    let result: String
    let response: String?
    let data: MangaDexDataEnum?
    let errors: [MangaDexErrorStruct]?
    let baseUrl: String?
    let chapter: ChapterImageUrlModel?
    let statuses: [String: String]?
    let token: [String: String]?
}

struct ChapterImageUrlModel: Decodable {
    let hash: String
    let data: [String]
    let dataSaver: [String]
}

struct MangaDexErrorStruct: Decodable, Error {
    let id: String
    let status: Int
    let title: String
}

//MARK: - MangaDex Data
enum MangaDexDataEnum: Decodable {
    case collection([MangaDexData])
    case entity(MangaDexData)
    case noData
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([MangaDexData].self) {
            self = .collection(x)
            return
        } else if let x = try? container.decode(MangaDexData.self) {
            self = .entity(x)
            return
        } else {
            self = .noData
            return
        }
    }
}


struct MangaDexData: Decodable {
    let id: String
    let type: MangaDexRelationshipType
    let attributes: MangaDexAttributes
    let relationships: [ChildMangaDexData]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case attributes
        case relationships
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        
        let typeString = try container.decode(String.self, forKey: .type)
        type = MangaDexRelationshipType.init(rawValue: typeString) ?? .unknownType
        attributes = try container.decode(MangaDexAttributes.self, forKey: .attributes)
        
        relationships = try container.decode([ChildMangaDexData].self, forKey: .relationships)
    }
}

struct ChildMangaDexData: Decodable {
    let id: String
    let type: MangaDexRelationshipType
    var attributes: MangaDexAttributes? = nil
    var related: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case attributes
        case related
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        
        let typeString = try container.decode(String.self, forKey: .type)
        type = MangaDexRelationshipType.init(rawValue: typeString) ?? .unknownType
        if container.contains(.attributes) {
            attributes = try container.decode(MangaDexAttributes.self, forKey: .attributes)
        }
        if container.contains(.related) {
            related = try container.decode(String.self, forKey: .related)
        }
    }
}

//MARK: - MangaDex Attributes
enum MangaDexAttributes: Decodable {

    case manga(RawMangaModel)
    case creator(RawCreatorModel)
    case cover(MangaCoverModel)
    case chapter(RawMangaChapterModel)
    case tag(RawTagModel)
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(RawMangaModel.self) {
            self = .manga(x)
            return
        } else if let x = try? container.decode(RawCreatorModel.self) {
            self = .creator(x)
            return
        } else if let x = try? container.decode(RawTagModel.self) {
            self = .tag(x)
            return
        } else if let x = try? container.decode(MangaCoverModel.self) {
            self = .cover(x)
            return
        } else if let x = try? container.decode(RawMangaChapterModel.self) {
            self = .chapter(x)
            return
        } else {
            self = .unknown
            return
        }
    }
}

struct RawTagModel: Decodable {
    let name: MultiLanguageText
}

struct MangaCoverModel: Decodable {
    let fileName: String
}


struct RawCreatorModel: Decodable {
    let name: String
}

struct MultiLanguageText: Decodable {
    let en: String?
    
    enum CodingKeys: String, CodingKey {
        case en
    }
    
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            en = try container.decode(String.self, forKey: .en)
        } catch {
            en = ""
        }

    }
}

struct RawMangaModel: Decodable {
    let title: MultiLanguageText
    let description: MultiLanguageText
    let contentRating: ContentRating
    let status: MangaStatus
    let publicationDemographic: PublicationDemographic
    let tags: [MangaDexData]
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case contentRating
        case status
        case publicationDemographic
        case tags
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(MultiLanguageText.self, forKey: .title)
        description = try container.decode(MultiLanguageText.self, forKey: .description)
        
        do {
            let rating = try container.decode(String.self, forKey: .contentRating)
            contentRating = ContentRating.init(rawValue: rating) ?? .unknown
        } catch {
            contentRating = .unknown
        }
        
        do {
            let mangaStatus = try container.decode(String.self, forKey: .status)
            status = MangaStatus.init(rawValue: mangaStatus) ?? .unknown
        } catch {
            status = .unknown
        }
        
        do {
            let demographic = try container.decode(String.self, forKey: .publicationDemographic)
            publicationDemographic = PublicationDemographic.init(rawValue: demographic) ?? .unknown
        } catch {
            publicationDemographic = .unknown
        }
        
        tags = try container.decode([MangaDexData].self, forKey: .tags)
    }

}


struct RawMangaChapterModel: Decodable {
    let chapter: String
    let title: String
}
