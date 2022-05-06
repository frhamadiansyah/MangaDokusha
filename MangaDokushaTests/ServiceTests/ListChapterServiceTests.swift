//
//  ListChapterServiceTests.swift
//  MangaDokushaTests
//
//  Created by Fandrian Rhamadiansyah on 04/05/22.
//

import XCTest
import Combine
@testable import MangaDokusha

class ListChapterServiceTests: XCTestCase {
    
    var apiService: Requestable!
    var sut: ListChapterService!
    var dummyRequest: URLRequest!
    
    var cancel = Set<AnyCancellable>()

    override func setUp() {
        apiService = MockApiServer(mockType: .errorNoUser)
        sut = ListChapterService(apiService: apiService)
        dummyRequest = sut.generateListChapterRequest(mangaId: "")
    }
    
    override func tearDown() {
        apiService = nil
        sut = nil
    }
    

    func testHandleBackendError() throws {
        
        sut.getListChapter(request: dummyRequest)
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
        apiService = MockApiServer(mockType: .listChapter)
        sut = ListChapterService(apiService: apiService)

        sut.getListChapter(request: dummyRequest)
            .sink { complete in
                switch complete {
                case .finished:
                    XCTAssert(true, "Finish received")
                    return
                case .failure(let error):
                    XCTFail("not success, but \(error) instead")
                }
            } receiveValue: { model in
                XCTAssert(model.first?.id == "5dce526a-e499-4f47-acb6-22f37d554759", "receive different id")
            }.store(in: &cancel)

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

