//
//  ReadChapterServiceTests.swift
//  MangaDokushaTests
//
//  Created by Fandrian Rhamadiansyah on 06/05/22.
//

import XCTest
import Combine
@testable import MangaDokusha

class ReadChapterServiceTests: XCTestCase {

    var apiService: Requestable!
    var sut: ReadChapterService!
    var dummyRequest: URLRequest!
    
    var cancel = Set<AnyCancellable>()

    override func setUp() {
        apiService = MockApiServer(mockType: .errorNoUser)
        sut = ReadChapterService(apiService: apiService)
        dummyRequest = sut.getReadChapterRequest(chapterId: "")
    }
    
    override func tearDown() {
        apiService = nil
        sut = nil
    }
    

    func testHandleBackendError() throws {
        
        sut.getChapterImageModel(request: dummyRequest)
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
        apiService = MockApiServer(mockType: .chapterImageUrls)
        sut = ReadChapterService(apiService: apiService)

        sut.getChapterImageModel(request: dummyRequest)
            .sink { complete in
                switch complete {
                case .finished:
                    XCTAssert(true, "Finish received")
                    return
                case .failure(let error):
                    XCTFail("not success, but \(error) instead")
                }
            } receiveValue: { model in
                let expectedSize = 37
                let resultSize = model.imageUrls.count
                
                XCTAssert(expectedSize == resultSize, "different array size, expected \(expectedSize) instead got \(resultSize)")
                
                let expectedUrl = "https://uploads.mangadex.org/data/60f2f99e0dc04e191a92e9c326ef5de1/1-9f18837be89e0dbac87dabd37055e69cec40690fb3fea50f8e61a28781e3e22f.png"
                let resultUrl = model.imageUrls.first
                XCTAssert(expectedUrl == resultUrl, "different urls, expected \(expectedUrl) instead got \(resultUrl)")
                
                let expectedSaverUrl = "https://uploads.mangadex.org/data-saver/60f2f99e0dc04e191a92e9c326ef5de1/1-b6cda852b501a5ae037279c2ebb86bef5b55d5b040f217b14f13fd6b82e89d17.jpg"
                let resultSaverUrl = model.saverImageUrls.first
                XCTAssert(expectedSaverUrl == resultSaverUrl, "different saver urls, expected \(expectedSaverUrl) instead got \(resultSaverUrl)")
                
            }.store(in: &cancel)

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
