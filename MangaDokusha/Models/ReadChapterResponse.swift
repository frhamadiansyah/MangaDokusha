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
