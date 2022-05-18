//
//  DownloadsViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 13/05/22.
//

import Foundation
import CoreData

class DownloadsViewModel: BaseViewModel {
    let manager = CoreDataManager.instance
    let fileManager = LocalFileManager.shared
    
    @Published var mangas: [MangaEntity] = []
    
    
    @MainActor
    func deleteItems(offsets: IndexSet) async {
    offsets.map { mangas [$0] }.forEach(manager.delete)
        do {
            try await manager.save2()
            try await getMangas()
        } catch {
            basicHandleError(error)
        }
    }
    
    func fetchMangas() async throws -> [MangaEntity] {
        let request = NSFetchRequest<MangaEntity>(entityName: "MangaEntity")
        
        let sort = NSSortDescriptor(keyPath: \MangaEntity.title, ascending: true)
        request.sortDescriptors = [sort]
        
        return try await manager.context.perform {
            return try request.execute()
        }
    }
    
    @MainActor
    func getMangas() async {
        do {
            mangas = try await fetchMangas()
        } catch let err {
            basicHandleError(err)
        }
        
    }
    
    func deleteAll() {
        Task {
            try await manager.deleteAll()
            try await getMangas()
            fileManager.deleteAll()
        }
    }
}
