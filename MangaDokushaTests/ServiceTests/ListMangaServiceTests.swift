//
//  ListMangaServiceTests.swift
//  MangaDokushaTests
//
//  Created by Fandrian Rhamadiansyah on 01/05/22.
//

import XCTest
import Combine
@testable import MangaDokusha

class ListMangaServiceTests: XCTestCase {
    
    var apiService: Requestable!
    var sut: ListMangaService!
    var dummyRequest: URLRequest!
    
    var cancel = Set<AnyCancellable>()

    override func setUp() {
        apiService = MockApiServer(mockType: .errorNoUser)
        sut = ListMangaService(apiService: apiService)
        dummyRequest = sut.generateListMangaRequest(mangaIds: [""])
    }
    
    override func tearDown() {
        apiService = nil
        sut = nil
    }
    

    func testHandleBackendError() throws {
        apiService = MockApiServer(mockType: .errorNoUser)
        sut = ListMangaService(apiService: apiService)
        
        sut.getListManga(request: dummyRequest)
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
        apiService = MockApiServer(mockType: .listManga)
        sut = ListMangaService(apiService: apiService)

        sut.getListManga(request: dummyRequest)
            .sink { complete in
                switch complete {
                case .finished:
                    XCTAssert(true, "Finish received")
                    return
                case .failure(let error):
                    XCTFail("not success, but \(error) instead")
                }
            } receiveValue: { model in
                XCTAssert(model.last?.id == "75de5e90-9621-4c0f-899f-056a90ef0061", "receive different id")
            }.store(in: &cancel)

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
