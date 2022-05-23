//
//  LocalFileManager.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 17/05/22.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let shared = LocalFileManager()
    
    let manager = FileManager.default
    
    
    //MARK: - Save
    func saveImage(data: Data, name: String, chapter: String, manga: String) {
        
        guard
            let path = getPathForImage(name: name, chapter: chapter, manga: manga) else {
            print("Error getting data")
            return
        }
        
        
        do {
            try data.write(to: path)
            print("✅ success saving")
        } catch {
            print("❌ error saving : \(error)")
        }
        
    }
    
    //MARK: - Fetch
    
    func getImage(name: String, chapter: String, manga: String) -> UIImage? {
        guard
            let path = getPathForImage(name: name, chapter: chapter, manga: manga)?.path,
            FileManager.default.fileExists(atPath: path) else {
            print("error getting path")
            return nil
        }
        
        return UIImage(contentsOfFile: path)
    }
    
    //MARK: - Get Path

    func getDirectoryPath(_ base: URL,_ dir: String) -> URL? {
        let pathUrl = base.appendingPathComponent(dir)
        let exist = manager.fileExists(atPath: pathUrl.path)
        
        if exist {
            return pathUrl
        } else {
            do {
                try manager.createDirectory(at: pathUrl,
                                            withIntermediateDirectories: true,
                                            attributes: [:])
                return pathUrl
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
    }
    
    func getPathForImage(name: String, chapter: String, manga: String) -> URL? {
        guard let base = manager
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first
        else { return nil }
        
        guard let mangaPath = getDirectoryPath(base, manga) else { return nil }
        
        guard let chapterPath = getDirectoryPath(mangaPath, chapter) else { return nil }
        
        let filePath = chapterPath.appendingPathComponent("\(name)")

        return filePath
        
    }
    
    //MARK: - Delete
    func deletePath(_ pathUrl: URL) {

        do {
            try FileManager.default.removeItem(at: pathUrl)
            print("successfully deleted")
        } catch let error {
            print("error deleting file : \(error)")
        }
    }
    
    func deleteChapter(chapter: String, manga: String) {
        guard let base = manager
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first
        else { return }
        
        guard let mangaPath = getDirectoryPath(base, manga) else { return }
        
        guard let chapterPath = getDirectoryPath(mangaPath, chapter) else { return }
        
        deletePath(chapterPath)
    }
    
    func deleteManga(manga: String) {
        guard let base = manager
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first
        else { return }
        
        guard let mangaPath = getDirectoryPath(base, manga) else { return }
        
        deletePath(mangaPath)
    }
    
    func deleteAll() {
        guard let documentsUrl = manager
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first
        else { return }
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch  {
            print(error)
            
        }
        
    }
}
