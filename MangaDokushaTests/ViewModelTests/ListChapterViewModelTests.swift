//
//  ListChapterViewModelTests.swift
//  MangaDokushaTests
//
//  Created by Fandrian Rhamadiansyah on 04/05/22.
//

import XCTest
import Combine
@testable import MangaDokusha

class ListChapterViewModelTests: XCTestCase {
    
    var apiService: Requestable!
    var chapterService: ListChapterService!
    var sut: ListChapterViewModel!
    var mockManga: MangaModel!
    
    override func setUp() {
        apiService = MockApiServer(mockType: .listChapter)
        chapterService = ListChapterService(apiService: apiService)
        
        let mockMangaMod = MockData.getMangaDexResponse(type: .manga)
        guard case .entity(let model) = mockMangaMod?.data else { return }
        mockManga = MangaModel(model)
        sut = ListChapterViewModel(manga: mockManga)
        sut.listChapterService = chapterService
    }
    
    override func tearDown() {
        apiService = nil
        chapterService = nil
        sut = nil
    }
    
    func testHandleBackendError() throws {
        apiService = MockApiServer(mockType: .errorNoUser)
        chapterService = ListChapterService(apiService: apiService)
        sut = ListChapterViewModel(manga: mockManga)
        sut.listChapterService = chapterService
        
        let expectation = expectation(description: "Error thrown")
        sut.loadInitialChapterList()
        
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
        sut.loadInitialChapterList()
        
        let expectation = expectation(description: "Load Initial chapter")
        // check mangaModel received
        sut.listChapter.publisher
            .first()
            .sink { models in
                XCTAssert(models.id == "5dce526a-e499-4f47-acb6-22f37d554759", "receive different id")
                
                let countExpected = 10
                let countResult = self.sut.listChapter.count
                XCTAssert(countResult == countExpected , "chapter count different, expected \(countExpected), instead got \(countResult)")
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 5)
    }
    
    func test_ScrollToThirdChapter_noLoadNewChapter() {
        let expectation = expectation(description: "Load Initial chapter")
        
        sut.loadInitialChapterList()
        
        sut.listChapter.publisher
            .output(at: 4)
            .sink { model in
                
                self.sut.loadMoreIfNeeded(currentChapter: model)
                let countExpected = 10
                let countResult = self.sut.listChapter.count
                XCTAssert(countResult == countExpected , "chapter count different, expected \(countExpected), instead got \(countResult)")
                expectation.fulfill()
            }

        wait(for: [expectation], timeout: 3)
    }
    
    func test_ScrollToFifthChapter_LoadNewChapter() {
        let expectation = expectation(description: "Load Initial chapter")
        
        sut.loadInitialChapterList()
        
        sut.listChapter.publisher
            .output(at: 5)
            .sink { model in
                
                self.sut.loadMoreIfNeeded(currentChapter: model)
                let offsetExpected = self.sut.limit
                let offsetResult = self.sut.offset
                XCTAssert(offsetResult == offsetExpected , "offset count different, expected \(offsetExpected), instead got \(offsetResult)")
                
                let countExpected = 20
                let countResult = self.sut.listChapter.count
                XCTAssert(countResult == countExpected , "chapter count different, expected \(countExpected), instead got \(countResult)")
                expectation.fulfill()
            }

        wait(for: [expectation], timeout: 3)
    }
    
    func test_ChangeFromAscendingToDescending_Load10Chapter() {
        let exp = expectation(description: "Load Initial chapter")

        sut.loadInitialChapterList()

        sut.listChapter.publisher
            .output(at: 5)
            .sink { model in

                self.sut.loadMoreIfNeeded(currentChapter: model)
                let countExpected = 20
                let countResult = self.sut.listChapter.count
                XCTAssert(countResult == countExpected , "chapter count different, expected \(countExpected), instead got \(countResult)")
                exp.fulfill()
            }
        let exp2 = expectation(description: "Change Ascending to Descending")
        sut.isAscending = false
        
        sut.listChapter.publisher
            .first()
            .sink { _ in
                let countExpected = 10
                let countResult = self.sut.listChapter.count
                XCTAssert(countResult == countExpected , "chapter count different, expected \(countExpected), instead got \(countResult)")
                exp2.fulfill()
            }

        wait(for: [exp, exp2], timeout: 3)
    }
    
}

