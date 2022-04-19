//
//  NetworkError.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 11/04/22.
//

import Foundation


enum MangaDokushaError: Error {
    case networkError(Error)
    case backendError(BackendError)
    case noChapter
}


struct BackendError: Decodable, Error {
    let result: String
    let errors: [BackendErrorMessage]
}

struct BackendErrorMessage: Decodable, Identifiable {
    let id: String
    let status: Int
    let title: String
    let detail: String
}
