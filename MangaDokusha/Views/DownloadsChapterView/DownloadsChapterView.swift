//
//  DownloadsChapterView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 13/05/22.
//

import SwiftUI

struct DownloadsChapterView: View {
    @StateObject var vm: DownloadsChapterViewModel
    
    init(entity: MangaEntity) {
        _vm = StateObject(wrappedValue: DownloadsChapterViewModel(entity: entity))
    }
    
    var body: some View {
        List {
            ForEach(vm.chapters) { chapter in
                Text(chapter.chapter ?? "")
                    
            }
            .onDelete { index in
                delete(index: index)
            }
            
        }
        
        .onAppear {
            vm.getChapter()
        }
    }
    
    func delete(index: IndexSet) {
        for i in index {
            let entity = vm.chapters[i]
            vm.deleteEntity(entity: entity)
        }
        vm.getChapter()
//        let entity = vm.chapters[index.count]
//        print(entity)
    }
}

struct DownloadsChapterView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadsChapterView(entity: MangaEntity())
    }
}
