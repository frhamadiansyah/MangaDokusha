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
    
    func saveImage(data: Data, name: String) {
        
        guard
            let path = getPathForImage(name: name) else {
            print("Error getting data")
            return
        }
        
        
        do {
            try data.write(to: path)
            print("✅ success saving")
        } catch let error {
            print("❌ error saving : \(error)")
        }
        
    }
    
    func getImage(name: String) -> UIImage? {
        guard
            let path = getPathForImage(name: name)?.path,
            FileManager.default.fileExists(atPath: path) else {
            print("error getting path")
            return nil
        }
        
        return UIImage(contentsOfFile: path)
    }
    
    func getPathForImage(name: String) -> URL? {
        guard let path = FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("\(name)")
        else { return nil }
        
        return path
    }
    
    func deleteImage(name: String) {
        guard
            let path = getPathForImage(name: name),
            FileManager.default.fileExists(atPath: path.path) else {
            print("error getting path")
            return
        }
        
        do {
            try FileManager.default.removeItem(at: path)
            print("successfully deleted")
        } catch let error {
            print("error deleting file : \(error)")
        }
    }
    
    func deleteAll() {
        guard let documentsUrl = FileManager
            .default
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
