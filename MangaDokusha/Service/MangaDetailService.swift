//
//  MangaDetailService.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 06/04/22.
//

import Foundation
import Combine

struct MangaDetailService {
    
    let apiService: Requestable

    func getMangaRequest(mangaId: String) -> URLRequest {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.mangadex.org"
        components.path = "/manga/\(mangaId)"
        components.queryItems = [
            URLQueryItem(name: "includes[]", value: "cover_art"),
            URLQueryItem(name: "includes[]", value: "author"),
            URLQueryItem(name: "includes[]", value: "artist"),
        ]
        let url = components.url
        return URLRequest(url: url!)
    }
    
    func getMangaDetail(request: URLRequest) -> AnyPublisher<MangaDetailResponse, Error> {
        apiService.make(request: request, decoder: JSONDecoder())
   
    }
    
    func getMangaDetail(mangaId: String) -> AnyPublisher<MangaDetailResponse, Error> {
        apiService.make(request: getMangaRequest(mangaId: mangaId), decoder: JSONDecoder())
            
   
    }
}


