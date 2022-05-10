//
//  MockApiService.swift
//  MangaDokushaTests
//
//  Created by Fandrian Rhamadiansyah on 01/05/22.
//

import Foundation
import Combine
import XCTest
@testable import MangaDokusha

struct MockApiServer: Requestable {
    
    var mockType: MockDataType
    
    mutating func changeMockType(type: MockDataType) {
        mockType = type
    }
    
    func make(request: URLRequest, decoder: JSONDecoder) -> AnyPublisher<MangaDexResponse, Error> {
        Just(MockData.getMangaDexResponse(type: mockType))
            .tryMap({ response in
                if let error = response?.errors?.first {
                    throw MangaDokushaError.backendError(error)
                } else {
                    return response!
                }
            })
//            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    
}
