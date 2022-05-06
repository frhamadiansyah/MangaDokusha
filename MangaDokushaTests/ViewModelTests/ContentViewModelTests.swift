//
//  ContentViewModelTests.swift
//  MangaDokushaTests
//
//  Created by Fandrian Rhamadiansyah on 04/05/22.
//

import XCTest
import Combine
@testable import MangaDokusha

class ContentViewModelTests: XCTestCase {
    
    var apiService: Requestable!
    var mangaService: MangaService!
    var sut: ContentViewModel!

    override func setUp() {
        apiService = MockApiServer(mockType: .manga)
        mangaService = MangaService(apiService: apiService)
        sut = ContentViewModel(mangaId: "")
        sut.mangaService = mangaService
    }
    
    override func tearDown() {
        apiService = nil
        mangaService = nil
        sut = nil
    }
    
    func testHandleBackendError() throws {
        apiService = MockApiServer(mockType: .errorNoUser)
        mangaService = MangaService(apiService: apiService)
        sut = ContentViewModel(mangaId: "")
        sut.mangaService = mangaService
        
        let expectation = expectation(description: "Error thrown")
        let urlReq = sut.getDetailMangaRequest(mangaId: "")
        sut.getDetailManga(urlRequest: urlReq)
        
        // check error handled
        sut.error.publisher.sink { error in
            guard case .backendError(let err) = error else {
                XCTFail("different error received")
                return
            }
            XCTAssert(err.status == 401, "different error status received")
            XCTAssert(self.sut.showError, "show error not toggled")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)

    }
    
    func testReceivedCorrectManga() {
        let expectation = expectation(description: "Manga Received")
        let urlReq = sut.getDetailMangaRequest(mangaId: "")
        sut.getDetailManga(urlRequest: urlReq)
        
        // check mangaModel received
        sut.mangaModel.publisher.sink { model in
            XCTAssert(model.id == "b9b2fbc4-e351-406c-a468-799be14033df", "receive different id")
            
            //check tags
            let expectedTags = ["Romance", "Comedy", "Harem", "School Life", "Slice of Life"]
            let resultTags = model.tags
            XCTAssert(expectedTags == resultTags, "receive different tags")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
        

    
    
}
