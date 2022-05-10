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
        print(urlString)
        let url = URL(string: urlString)!
        return URLRequest(url: url)
    }
    
    func getChapterImageModel(request: URLRequest) -> AnyPublisher<ReadChapterModel, MangaDokushaError> {
        apiService.make(request: request, decoder: JSONDecoder())
            .tryMap({ response -> ReadChapterModel in
                let result = ReadChapterModel(response)
                if !result.imageUrls.isEmpty {
                    return ReadChapterModel(response)
                }
                    
                throw MangaDokushaError.backendError(MangaDexErrorStruct(
                    id: UUID().uuidString,
                    status: 1,
                    title: "Chapter images is empty. Check mangadex docs for updates"
                ))
                
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
