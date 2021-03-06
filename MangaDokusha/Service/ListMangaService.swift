//
//  ListMangaService.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 11/04/22.
//

import Foundation
import Combine

struct ListMangaService {
    
    let apiService: Requestable
    
    func generateBaseRequest(limit: Int = queryLimit, offset: Int = 0) -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.mangadex.org"
        components.path = "/manga"
        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)"),
    
            // add all contentRating
            URLQueryItem(name: "contentRating[]", value: ContentRating.pornographic.rawValue),
            URLQueryItem(name: "contentRating[]", value: ContentRating.suggestive.rawValue),
            URLQueryItem(name: "contentRating[]", value: ContentRating.erotica.rawValue),
            URLQueryItem(name: "contentRating[]", value: ContentRating.safeContent.rawValue),
    
            // add all include
            URLQueryItem(name: "includes[]", value: "cover_art"),
            URLQueryItem(name: "includes[]", value: "author"),
            URLQueryItem(name: "includes[]", value: "artist"),
    
        ]
        return components
    }
    
    func generateListMangaRequest(mangaIds: [String], limit: Int = queryLimit, offset: Int = 0) -> URLRequest {
        var components = generateBaseRequest(limit: limit, offset: offset)
    
        for item in mangaIds {
            components.queryItems?.append(URLQueryItem(name: "ids[]", value: item))
        }
    
        let url = components.url
        return URLRequest(url: url!)
    }
    
    func generateListMangaRequestByAuthor(authorIds: [String], limit: Int = queryLimit, offset: Int = 0) -> URLRequest {
        var components = generateBaseRequest(limit: limit, offset: offset)
    
        for item in authorIds {
            components.queryItems?.append(URLQueryItem(name: "authors[]", value: item))
        }
    
        let url = components.url
        return URLRequest(url: url!)
    }
    
    func generateListMangaRequestByArtist(artistIds: [String], limit: Int = queryLimit, offset: Int = 0) -> URLRequest {
        var components = generateBaseRequest(limit: limit, offset: offset)
    
        for item in artistIds {
            components.queryItems?.append(URLQueryItem(name: "artists[]", value: item))
        }
    
        let url = components.url
        return URLRequest(url: url!)
    }
    
    func searchMangaRequest(title: String, limit: Int = queryLimit, offset: Int = 0) -> URLRequest {
        var components = generateBaseRequest(limit: limit, offset: offset)

        components.queryItems?.append(URLQueryItem(name: "title", value: title))
    
        let url = components.url
        return URLRequest(url: url!)
    }
    
    func getListManga(request: URLRequest) -> AnyPublisher<[MangaModel], MangaDokushaError> {
        apiService.make(request: request, decoder: JSONDecoder())
            .tryMap({ response -> [MangaModel] in
                if case .collection(let mangas) = response.data {
                    let result = mangas.map { MangaModel($0) }
                    return result

                } else {
                    throw MangaDokushaError.backendError(MangaDexErrorStruct(
                        id: UUID().uuidString,
                        status: 0,
                        title: "Different list manga response. Check mangadex docs for updates"
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
