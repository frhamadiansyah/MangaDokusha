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
