//
//  ApiService.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 06/04/22.
//

import Foundation
import Combine
//import SwiftyJSON

let baseUrl = "https://api.mangadex.org"
let imageBaseUrl = "https://uploads.mangadex.org"

let baseUrlScheme = "https"
let baseUrlHost = "api.mangadex.org"


protocol Requestable {
    func make(request: URLRequest, decoder: JSONDecoder) -> AnyPublisher<MangaDexResponse, Error>
}

struct APIService: Requestable {
    
    static let shared = APIService()
    
    func addBearerToken(request: URLRequest) -> URLRequest {
        var newRequest = request
        newRequest.setValue("application/json", forHTTPHeaderField:"Content-Type")
//        newRequest.setValue("Bearer \(bearerToken)", forHTTPHeaderField:"Authorization")
        return newRequest
    }

    
    func make<T: Decodable>(request: URLRequest, decoder: JSONDecoder) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: request)
            .map { response in
                response.data
            }
            .decode(type: T.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }

    func make(request: URLRequest, decoder: JSONDecoder) -> AnyPublisher<MangaDexResponse, Error> {
        URLSession.shared.dataTaskPublisher(for: addBearerToken(request: request))
            .mapError { urlError -> MangaDokushaError in
                return MangaDokushaError.networkError(urlError)
            }
            .tryMap({ output in
                do {
                    let result = try decoder.decode(MangaDexResponse.self, from: output.data)
                    if let error = result.errors?.first {
                        throw MangaDokushaError.backendError(error)
                    } else {
                        return result
                    }
                } catch let error {
                    throw MangaDokushaError.otherError(error)
                }
            })
        
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
