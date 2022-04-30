//
//  MangaDexResponseTests.swift
//  MangaDokushaTests
//
//  Created by Fandrian Rhamadiansyah on 30/04/22.
//

import XCTest
@testable import MangaDokusha

class MangaDexResponseTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_WhenInputGetMangaType_ReturnCorrectType() throws {
        let sut = MockData.getMangaDexResponse(type: .getManga)
        
        let data = sut?.data
        
        guard case .entity(let resultData) = data else {
            XCTFail("data not entity")
            return
        }
        guard case .manga(let model) = resultData.attributes else {
            XCTFail("attribute not manga entity")
            return
        }
        // check title
        let result = model.title.en!
        let expected = "Temple"
        
        XCTAssert(result == expected, "title different from expected, expect \(expected), but got \(result)")
        
        //check rating
        let ratingResult = model.contentRating
        let ratingExpected = ContentRating.suggestive
        
        XCTAssert(ratingResult == ratingExpected, "title different from expected, expect \(ratingExpected), but got \(ratingResult)")
        
        // check tag
        let tagAttrib = model.tags.first?.attributes
        
        guard case .tag(let tag) = tagAttrib else {
            XCTFail("attribute not tag entity")
            return
        }
        
        let tagResult = tag.name.en!
        let tagExpected = "Romance"
        
        XCTAssert(tagResult == tagExpected, "tag different from expected, expect \(tagExpected), but got \(tagResult)")
        
        
        guard let relationships = resultData.relationships else {
            XCTFail("no relationship")
            return
        }
        
        for item in relationships where item.type != .unknownType {
            // add relationship type to check
            if item.type == .author {
                guard case .creator(let creator) = item.attributes else {
                    XCTFail("no author entity found")
                    return
                }
                let res = creator.name
                let expect = "Yoshioka Kimitake"
                XCTAssert(res == expect, "scanlator different from expected, expect \(expect), but got \(res)")
            }
            
            if item.type == .cover {
                guard case .cover(let creator) = item.attributes else {
                    XCTFail("no cover entity found")
                    return
                }
                let res = creator.fileName
                let expect = "6cbef8e2-4bec-4da2-89c2-79f37fe082dd.png"
                XCTAssert(res == expect, "fileName different from expected, expect \(expect), but got \(res)")
            }
        }

    }
    
    func test_WhenInputGetListMangaType_ReturnCorrectType() throws {
        let sut = MockData.getMangaDexResponse(type: .getListManga)
        
        let data = sut?.data
        
        guard case .collection(let resultData) = data else {
            XCTFail("data not collection")
            return
        }
        let totalMangaResult = resultData.count
        let totalMangaExpected = 10
        XCTAssert(totalMangaResult == totalMangaExpected, "expected manga in list \(totalMangaExpected), but instead got \(totalMangaResult)")
        
        guard case .manga(let model) = resultData.first!.attributes else {
            XCTFail("attribute not manga entity")
            return
        }
        let result = model.title.en!
        let expected = "Soredemo Ayumu wa Yosetekuru"
        
        XCTAssert(result == expected, "title different from expected, expect \(expected), but instead got \(result)")

    }
    
    func test_WhenInputGetListMangaWithEmptyDesc_ReturnCorrectType() throws {
        let sut = MockData.getMangaDexResponse(type: .getMangaEmptyDesc)
        
        let data = sut?.data
        
        guard case .collection(let resultData) = data else {
            XCTFail("data not collection")
            return
        }
        let totalMangaResult = resultData.count
        let totalMangaExpected = 10
        XCTAssert(totalMangaResult == totalMangaExpected, "expected manga in list \(totalMangaExpected), but instead got \(totalMangaResult)")
        
        guard case .manga(let model) = resultData[2].attributes else {
            XCTFail("attribute not manga entity")
            return
        }
        let result = model.description.en!
        let expected = ""
        
        XCTAssert(result == expected, "title different from expected, expect \(expected), but instead got \(result)")

    }
    
    func test_WhenInputGetChapterType_ReturnCorrectType() throws {
        let sut = MockData.getMangaDexResponse(type: .getChapter)
        
        let data = sut?.data
        
        guard case .entity(let resultData) = data else {
            XCTFail("data not entity")
            return
        }
        guard case .chapter(let model) = resultData.attributes else {
            XCTFail("attribute not chapter entity")
            return
        }
        let result = model.chapter
        let expected = "60"
        
        XCTAssert(result == expected, "title different from expected, expect \(expected), but got \(result)")
        
        guard let relationships = resultData.relationships else {
            XCTFail("no relationship")
            return
        }
        
        for item in relationships where item.type != .unknownType {
            // add relationship type to check
            if item.type == .scanlation {
                guard case .creator(let creator) = item.attributes else {
                    XCTFail("no scanlator entity found")
                    return
                }
                let res = creator.name
                let expect = "Japanese Unloved Mangas (JUM)"
                XCTAssert(res == expect, "scanlator different from expected, expect \(expect), but got \(res)")
            }
            
            if item.type == .manga {
                guard case .manga(let creator) = item.attributes else {
                    XCTFail("no manga entity found")
                    return
                }
                let res = creator.title.en!
                let expect = "Rakujitsu no Pathos"
                XCTAssert(res == expect, "scanlator different from expected, expect \(expect), but got \(res)")
            }
        }
        

    }
    
    func test_WhenInputGetListChapterType_ReturnCorrectType() throws {
        let sut = MockData.getMangaDexResponse(type: .getListChapter)
        
        let data = sut?.data

        guard case .collection(let resultData) = data else {
            XCTFail("data not collection")
            return
        }
        let totalChapterResult = resultData.count
        let totalChapterExpected = 10
        XCTAssert(totalChapterResult == totalChapterExpected, "expected chapter in list \(totalChapterExpected), but instead got \(totalChapterResult)")
        
        guard case .chapter(let model) = resultData.first!.attributes else {
            XCTFail("attribute not chapter entity")
            return
        }
        let result = model.chapter
        let expected = "20"
        
        XCTAssert(result == expected, "title different from expected, expect \(expected), but got \(result)")
        
        guard let relationships = resultData.first!.relationships else {
            XCTFail("no relationship")
            return
        }
        
        for item in relationships where item.type != .unknownType {
            // add relationship type to check
            if item.type == .scanlation {
                guard case .creator(let creator) = item.attributes else {
                    XCTFail("no creator entity found")
                    return
                }
                let res = creator.name
                let expect = "AceraTheGreat"
                XCTAssert(res == expect, "scanlator different from expected, expect \(expect), but got \(res)")
            }
            
            if item.type == .manga {
                guard case .manga(let creator) = item.attributes else {
                    XCTFail("no manga entity found")
                    return
                }
                let res = creator.title.en!
                let expect = "Flirting With Her"
                XCTAssert(res == expect, "scanlator different from expected, expect \(expect), but got \(res)")
            }
        }

    }
    
    func test_WhenInputGetEmptyListType_ReturnCorrectType() throws {
        let sut = MockData.getMangaDexResponse(type: .getEmptyListManga)
        
        let data = sut?.data
        
        
        guard case .collection(let resultData) = data else {
            XCTFail("data not collection")
            return
        }
        let totalChapterResult = resultData.count
        let totalChapterExpected = 0
        XCTAssert(totalChapterResult == totalChapterExpected, "expected chapter in list \(totalChapterExpected), but instead got \(totalChapterResult)")


    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
