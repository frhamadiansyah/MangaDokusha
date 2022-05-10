//
//  ListChapterService.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 08/04/22.
//

import Foundation
import Combine

let queryLimit = 50

struct ListChapterService {
    let apiService: Requestable
    
    func generateBaseRequest(mangaId: String, limit: Int = queryLimit, offset: Int = 0) -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.mangadex.org"
        components.path = "/chapter"
        components.queryItems = [
            URLQueryItem(name: "manga", value: mangaId),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)"),
            
            // add all contentRating
            URLQueryItem(name: "contentRating[]", value: ContentRating.pornographic.rawValue),
            URLQueryItem(name: "contentRating[]", value: ContentRating.suggestive.rawValue),
            URLQueryItem(name: "contentRating[]", value: ContentRating.erotica.rawValue),
            URLQueryItem(name: "contentRating[]", value: ContentRating.safeContent.rawValue),
            
            // add all include
            URLQueryItem(name: "includes[]", value: "scanlation_group"),
            URLQueryItem(name: "includes[]", value: "manga"),
            URLQueryItem(name: "includes[]", value: "user"),
            
            URLQueryItem(name: "translatedLanguage[]", value: "en"),
            
        ]
        return components
    }
    
    func generateListChapterRequest(mangaId: String, limit: Int = queryLimit, offset: Int = 0, ascending: Bool = true) -> URLRequest {
        var components = generateBaseRequest(mangaId: mangaId, limit: limit, offset: offset)
        
        if ascending {
            components.queryItems?.append(URLQueryItem(name: "order[chapter]", value: "asc"))
        } else {
            components.queryItems?.append(URLQueryItem(name: "order[chapter]", value: "desc"))
        }
        
        let url = components.url
        return URLRequest(url: url!)
    }
    
    func generateNextOrPreviousChapterRequest(mangaId: String, currentChapter: String, createdAt: String, nextChapter: Bool) -> URLRequest {
        var components = generateBaseRequest(mangaId: mangaId)
        
        guard let chapter = Float(currentChapter) else { return URLRequest(url: components.url!) }
        let chapterInt = Int(chapter)
        
        if nextChapter {
            components.queryItems?.append(URLQueryItem(name: "createdAtSince", value: createdAt))
        } else {
            components.queryItems?.append(URLQueryItem(name: "chapter", value: "\(chapterInt - 1)"))
        }
        let url = components.url
        return URLRequest(url: url!)
    }
    
    func getListChapter(request: URLRequest) -> AnyPublisher<[ChapterModel], MangaDokushaError> {
        apiService.make(request: request, decoder: JSONDecoder())
            .tryMap({ response -> [ChapterModel] in
                if case .collection(let chapters) = response.data {
                    let result = chapters.map { ChapterModel($0) }
                    return result
                } else {
                    throw MangaDokushaError.backendError(MangaDexErrorStruct(
                        id: UUID().uuidString,
                        status: 0,
                        title: "Different list chapter response. Check mangadex docs for updates"
                    ))
                }
                
            })
            .mapError({ error -> MangaDokushaError in
                if let err = error as? MangaDokushaError {
                    print(err)
                    return err
                } else {
                    return MangaDokushaError.otherError(error)
                }
            })
            .eraseToAnyPublisher()
    
    }
    
}
