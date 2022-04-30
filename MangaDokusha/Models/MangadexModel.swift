//
//  MangadexModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 29/04/22.
//

import Foundation
//import SwiftyJSON
//



struct MangaDetailModelzx: Decodable {
    let id: String
    var title: String? = nil
    var description: String? = nil
    var artist: CreatorModel? = nil
    var author: CreatorModel? = nil
    var coverUrl: String = ""

    init(from decoder: Decoder) throws {
        let raw = try MangaDexResponse(from: decoder)
        
        let dataEnum = raw.data
        
        guard case .entity(let data) = dataEnum else {
            id = "error"
            return
        }
        
        id = data.id

        let attrib = data.attributes
        
        switch attrib {
        case .manga(let model):
            title = model.title.en
            description = model.description.en
        default:
            break
        }
        guard let sequence = data.relationships else {
            return }
        
        for item in sequence {
            if item.type == .artist {
                let id = item.id
                let att = item.attributes
                switch att {
                case .creator(let rawCreatorModel):
                    artist = CreatorModel(id: id, name: rawCreatorModel.name)
                default:
                    break
                }
            } else if item.type == .author {
                let id = item.id
                let att = item.attributes
                switch att {
                case .creator(let rawCreatorModel):
                    author = CreatorModel(id: id, name: rawCreatorModel.name)
                default:
                    break
                }
            } else if item.type == .cover {
                let att = item.attributes
                switch att {
                case .cover(let coverMod):
                    coverUrl = "\(imageBaseUrl)/covers/\(id)/\(coverMod.fileName)"
                default:
                    break
                }
            }
        }
    }

}


struct CreatorModel {
    let id: String
    let name: String
}

