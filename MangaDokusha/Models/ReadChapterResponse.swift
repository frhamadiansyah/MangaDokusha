//
//  ReadChapterResponse.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 08/04/22.
//

import Foundation

struct ReadChapterModel {
    let baseUrl: String
    var hash: String = ""
    var fileName: [String] = []
    var imageUrls: [String] = []
    var saverFileName: [String] = []
    var saverImageUrls: [String] = []
    
    init(_ response: MangaDexResponse) {
        baseUrl = response.baseUrl ?? ""
        guard let chapter = response.chapter else { return }
        
        hash = chapter.hash
        fileName.append(contentsOf: chapter.data)
        imageUrls = fileName.map({ name in
            return "\(baseUrl)/data/\(hash)/\(name)"
        })
        saverFileName.append(contentsOf: chapter.dataSaver)
        saverImageUrls = saverFileName.map({ name in
            return "\(baseUrl)/data-saver/\(hash)/\(name)"
        })
    }
}

//struct ReadChapterModel: Decodable {
//    let baseUrl: String
//    let hash: String
//    let fileName: [String]
//    var imageUrl: [String]
//
//    init(from decoder: Decoder) throws {
//        let rawResponse = try RawReadChapterModel(from: decoder)
//
//        baseUrl = rawResponse.baseUrl
//        hash = rawResponse.chapter.hash
//        fileName = rawResponse.chapter.data
//
//        imageUrl = [String]()
//        for item in fileName {
//            let url = "\(baseUrl)/data/\(hash)/\(item)"
//            imageUrl.append(url)
//        }
//    }
//}


fileprivate struct RawReadChapterModel: Decodable {

    struct RawChapterResponse: Decodable {
        let hash: String
        let data: [String]
    }
    
    let baseUrl: String
    let chapter: RawChapterResponse
}
