////
////  MangaDetailService.swift
////  MangaDokusha
////
////  Created by Fandrian Rhamadiansyah on 06/04/22.
////
//
import Foundation
import Combine

struct MangaService {
    
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
    
    func getManga(request: URLRequest) -> AnyPublisher<MangaModel, MangaDokushaError> {
        apiService.make(request: request, decoder: JSONDecoder())
            .tryMap({ response -> MangaModel in
                if case .entity(let manga) = response.data {
                    return MangaModel(manga)
                } else {
                    throw MangaDokushaError.backendError(MangaDexErrorStruct(
                        id: UUID().uuidString,
                        status: 1,
                        title: "Different manga response. Check mangadex docs for updates"
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
