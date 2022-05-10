//
//  MangaServiceTests.swift
//  MangaDokushaTests
//
//  Created by Fandrian Rhamadiansyah on 01/05/22.
//

import XCTest
import Combine
@testable import MangaDokusha

class MangaServiceTests: XCTestCase {
    
    var apiService: Requestable!
    var sut: MangaService!
    
    var cancel = Set<AnyCancellable>()

    override func setUp() {
        apiService = MockApiServer(mockType: .errorNoUser)
        sut = MangaService(apiService: apiService)
    }
    
    override func tearDown() {
        apiService = nil
        sut = nil
    }
    

    func testHandleBackendError() throws {
        apiService = MockApiServer(mockType: .errorNoUser)
        sut = MangaService(apiService: apiService)
        
        let request = sut.getMangaRequest(mangaId: "")
        sut.getManga(request: request)
            .sink { complete in
                switch complete {
                case .finished:
                    XCTFail("Error not received, finish instead")
                    return
                case .failure(let error):
                    guard case .backendError(let err) = error else {
                        XCTFail("not backend error, but \(error) instead")
                        return
                    }
                    XCTAssert(err.status == 401, "Different Status")
                }
            } receiveValue: { model in
                print(model)
                XCTFail("Error not received, finish instead")
            }.store(in: &cancel)

    }
    
    func testHandleSuccessResult() throws {
        apiService = MockApiServer(mockType: .manga)
        sut = MangaService(apiService: apiService)

        let request = sut.getMangaRequest(mangaId: "")
        sut.getManga(request: request)
            .sink { complete in
                switch complete {
                case .finished:
                    XCTAssert(true, "Finish received")
                    return
                case .failure(let error):
                    XCTFail("not success, but \(error) instead")
                }
            } receiveValue: { model in
                XCTAssert(model.id == "b9b2fbc4-e351-406c-a468-799be14033df", "receive different id")
                
                //check tags
                let expectedTags = ["Romance", "Comedy", "Harem", "School Life", "Slice of Life"]
                let resultTags = model.tags
                XCTAssert(expectedTags == resultTags, "receive different tags")
                
            }.store(in: &cancel)

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
