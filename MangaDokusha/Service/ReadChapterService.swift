//
//  ReadChapterService.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 08/04/22.
//

import Foundation
import Combine

struct ReadChapterService {
    
    let apiService: Requestable

    func getReadChapterRequest(chapterId: String) -> URLRequest {
        
        let urlString = "\(baseUrl)/at-home/server/\(chapterId)"
//        let urlString = "\(baseUrl)/cover/\(coverId)"
        print(urlString)
        let url = URL(string: urlString)!
        return URLRequest(url: url)
    }
    
    func getListChapter(request: URLRequest) -> AnyPublisher<ReadChapterModel, Error> {
        apiService.make(request: request, decoder: JSONDecoder())
    
    }
    
    func getChapterImage(chapterId: String) -> AnyPublisher<ReadChapterModel, Error> {
        apiService.make(request: getReadChapterRequest(chapterId: chapterId), decoder: JSONDecoder())
    
    }
}
