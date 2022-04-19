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
    func make<T: Decodable>(request: URLRequest, decoder: JSONDecoder) -> AnyPublisher<T, Error>
}

struct APIService: Requestable {
    
    func addBearerToken(request: URLRequest) -> URLRequest {
        var newRequest = request
        newRequest.setValue("application/json", forHTTPHeaderField:"Content-Type")
        newRequest.setValue("Bearer \(bearerToken)", forHTTPHeaderField:"Authorization")
        return newRequest
    }
    
    
    func make<T: Decodable>(request: URLRequest, decoder: JSONDecoder) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: addBearerToken(request: request))
            .mapError({ urlError in
                return MangaDokushaError.networkError(urlError)
            })
            .tryMap { data, response -> T in
//                let test = try decoder.decode([String: String].self, from: data)
//                print(test)
                do {
                    let result = try decoder.decode(T.self, from: data)
                    return result
                } catch {
                    let errorResponse = try decoder.decode(BackendError.self, from: data)
                    throw MangaDokushaError.backendError(errorResponse)
                }

            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
}

struct Res: Decodable {
    let result: String
}


let bearerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ0eXAiOiJzZXNzaW9uIiwiaXNzIjoibWFuZ2FkZXgub3JnIiwiYXVkIjoibWFuZ2FkZXgub3JnIiwiaWF0IjoxNjQ5NjgyNDQ0LCJuYmYiOjE2NDk2ODI0NDQsImV4cCI6MTY0OTY4MzM0NCwidWlkIjoiOWUzMTJkZDMtNDVhZS00MjQ4LWI3NWEtNmVjM2MxNGE4NTNhIiwicm9sIjpbIlJPTEVfTUVNQkVSIl0sInBybSI6WyJ1c2VyLmxpc3QiLCJyZXBvcnQuY3JlYXRlIiwiY2hhcHRlci51cGxvYWQiLCJzY2FubGF0aW9uX2dyb3VwLmNyZWF0ZSIsImF1dGhvci5jcmVhdGUiLCJtYW5nYS5jcmVhdGUiLCJyYXRpbmcuY3JlYXRlIiwicmF0aW5nLmxpc3QiLCJyYXRpbmcuZGVsZXRlIiwic2V0dGluZ3MudmlldyIsInNldHRpbmdzLmVkaXQiLCJzZXR0aW5nc190ZW1wbGF0ZS52aWV3IiwidXNlci5hdmFpbGFibGUiLCJtYW5nYS52aWV3IiwiY2hhcHRlci52aWV3IiwiYXV0aG9yLnZpZXciLCJzY2FubGF0aW9uX2dyb3VwLnZpZXciLCJjb3Zlcl9hcnQudmlldyIsInVzZXIudmlldyIsIm1hbmdhLmxpc3QiLCJtYW5nYV9yZWxhdGlvbi5saXN0IiwiY2hhcHRlci5saXN0IiwiYXV0aG9yLmxpc3QiLCJzY2FubGF0aW9uX2dyb3VwLmxpc3QiLCJjb3Zlcl9hcnQubGlzdCJdLCJzaWQiOiI0MTIxYzZlZS0xMjZmLTQ5MmQtYWQ4ZC01OWZkZDFkZWJiNjIifQ.oXKxHOrPiPU-BdXiUZSvVoaYEjnaRp0p5SYdA7magCKVTRKTV6jNsvgJ3qY7dL9HKFQUlYLEHFEyV-Rb31bRNykcM1sPdaIQiG5EKVmpDFkqBb4A-nPtCAPljDpyxPaH9jDjCOMVL1XOJpKnY3J_gBPs0Fx8DgTw-3_Nl_8x0HdizSRYthpAShhyc8u1PfrOznbKrPwigvvO1Zva09SWs-eqTXC4SGc5ejzJ-7hLcFYjpGtuxRuZ7YVsyYXkQ2UzYPGNX-GkMI2xk-dswzKqnzHv5Zv7QiAY0_sK7eLMoCpAea3PZbfgfxNEzqYshjCE2Gv55MGXCx8XI3gWe-SSLyXFqeAe07twlwiX7L_aPpMGKf4uDaBDL-E-W8p2EOjYG1aVCySDWyG0Q-LKdkMUiV-JqCXuXTwATeIb2MiuwVwtgEWoCHcxEelNveezGmIF4ot7oiAr-Wjaqk0mQ38whB-wgih1TJJ3qtdzpfzPKfnTJw46f_M6UJxlIpYNdowxhb1PwY8e9gQRlAoAmgFdoxalOpcJGnO1FsqEQl-wxJdjUxcagqQeqp7doEA1fFMj5OCzozizrBxJ_LE5QJdbfUaOGM3SacD0hZGNVqdc4BUnwmun7OKZa-kCXaA1F0gr19u3fxr4-VMwLDNhrth9z3zJ2MzOGLTo165Pr-cSTI4"