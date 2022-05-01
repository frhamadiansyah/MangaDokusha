//
//  MockData.swift
//  MangaDokushaTests
//
//  Created by Fandrian Rhamadiansyah on 29/04/22.
//

import Foundation

@testable import MangaDokusha

enum MockDataType: String {
    case manga = "mockManga"
    case listManga = "mockListManga"
    case chapter = "mockChapter"
    case listChapter = "mockListChapter"
    case emptyListManga = "mockEmptyListManga"
    case mangaEmptyDesc = "mockMangaEmptyDesc"
    case errorNoUser = "mockErrorNoUser"
    
}


class MockData {
    
    static func getMangaDexResponse(type: MockDataType) -> MangaDexResponse? {
        if let data = readLocalFile(forName: type.rawValue) {
            do {
                let result = try JSONDecoder().decode(MangaDexResponse.self, from: data)
                return result
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func getMockData<T:Decodable>(type: MockDataType) -> T? {
        if let data = readLocalFile(forName: type.rawValue) {
            do {
//                let response = try JSONDecoder().decode(MangaDexResponse.self, from: data)
                let result = try JSONDecoder().decode(T.self, from: data)
                return result
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    private static func getMockRawData(type: MockDataType) -> Data {
        return readLocalFile(forName: type.rawValue) ?? Data()
    }
    
    private static func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle(for: MockData.self).path(forResource: name, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
}

