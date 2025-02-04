//
//  ReadDownloadedViewModel.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 14/05/22.
//

import Foundation
import CoreData
import UIKit

class ReadDownloadedViewModel: BaseViewModel {
    
    let entity: ChapterEntity
    let manager = CoreDataManager.instance
    let fileManager = LocalFileManager.shared
    
    @Published var imageUrls = [String]()
    @Published var images = [UIImage]()
    
    @Published var pageTitle = ""
    
    @Published var count = 0
    
    init(entity: ChapterEntity) {
        self.entity = entity
    }
    
    func getPages() {
        pageTitle = "Chapter \(entity.chapter.toString())"
        
        let request = NSFetchRequest<PageEntity>(entityName: "PageEntity")
        
        let sort = NSSortDescriptor(keyPath: \PageEntity.pageNumber, ascending: true)
        request.sortDescriptors = [sort]
        
        let filter = NSPredicate(format: "chapter == %@", entity)
        request.predicate = filter
        
        do {
            let pages = try manager.context.fetch(request)
            imageUrls = pages.map({$0.id ?? ""})
            
            let chapterId = entity.id ?? ""
            let mangaId = entity.manga?.id ?? ""
            
            for i in pages {
                let pageId = i.id ?? ""
                let page = fileManager.getImage(name: pageId, chapter: chapterId, manga: mangaId)
                
                images.append(page ?? UIImage())
            }
        } catch let error {
            print("Error fetching : \(error.localizedDescription)")
        }

    }
}

extension ReadDownloadedViewModel {
    
    func distributeNextPage() -> [UIImage] {
        var result = [UIImage]()
        guard count >= 0 && count < images.count else {return result}
        

        //append first image
        if images[count].isLandscape()  || images[count + 1].isLandscape() {
            result.append(images[count])
            print(count)
            return result
        } else {
            
            result.append(images[count])
        }
        
        //append
        if count + 1 < images.count - 1 {
            result.append(images[count + 1])
            count += 1
        }
        print(count)
        
        return result
    }
    
    func distributePreviousPage(currentPages: [UIImage]) -> [UIImage] {
        var result = [UIImage]()
        print(count)
        guard count >= 0 && count + 1 < images.count else {return result}
        
        if images[count + 1].isLandscape() && images[count].isLandscape() {
            result.append(images[count])
            return result
        } else if images[count + 1].isLandscape() && !images[count].isLandscape() {
//            if images[count - 1].isLandscape() {
                result.append(images[count])
//                count += 1
                return result
//            } else {
//                result.append(images[count])
//                result.append(images[count - 1])
//                count -= 1
//                return result.reversed()
//            }
        } else if images[count].isLandscape() {
            result.append(images[count])
            return result
        } else if currentPages.count == 1 {
            result.append(images[count])
            result.append(images[count - 1])
//            count -= 1
            return result.reversed()
        } else {
            result.append(images[count - 1])
            result.append(images[count - 2])
            count -= 1
            return result.reversed()
        }
//        if
//
//        //if prev spread and current spread
//        if images[count].isLandscape() {
//            result.append(images[count])
//            return result
//        }
//
//        guard count - 1 >= 0 && count + 1 < images.count else {return result}
//        if !images[count].isLandscape() && images[count + 1].isLandscape() {
//            if images[count - 1].isLandscape() {
//                result.append(images[count])
//                return result
//            }
//            result.append(images[count])
//            result.append(images[count-1])
//            count -= 1
//            return result.reversed()
//        }
//
//        guard count - 2 >= 0 && count + 1 < images.count else {return result}
//
//        if images[count-1].isLandscape() {
//            result.append(images[count - 1])
//            return result
//        }
////        result.append(images[count - 1])
//        if !images[count-2].isLandscape() {
//            result.append(images[count - 1])
//            result.append(images[count - 2])
//        }
//        count -= 1
//        return result.reversed()
        
//        if !images[count + 1].isLandscape() {
//            count -= 1
//        }
        // check page second
//        if images[count].isLandscape() {
//            result.append(images[count])
//            return result
//        } else {
//            result.append(images[count])
//        }
//
//        if count - 1 >= 0 {
//            result.append(images[count - 1])
//            count -= 1
//        }
//
//
//        return result.reversed()
    }
    
}
