//
//  DownloadsChapterView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 13/05/22.
//

import SwiftUI

struct DownloadsChapterView: View {
    @StateObject var vm: DownloadsChapterViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(entity: MangaEntity) {
        _vm = StateObject(wrappedValue: DownloadsChapterViewModel(entity: entity))
    }
    
    var body: some View {
        List {
            ForEach(vm.chapters) { chapter in
                NavigationLink {
                    ReadDownloadedView(entity: chapter)
                } label: {
                    HStack {
                        Text("\(chapter.chapter ?? "") :")
                        Text("\(chapter.chapterTitle ?? "")")
                    }
                }
                    
            }
            .onDelete { index in
                delete(index: index)
            }
            
        }
        .navigationTitle(vm.mangaTitle)
        
        .onAppear {
            vm.getChapter()
        }
    }
    
    func delete(index: IndexSet) {
        for i in index {
            let entity = vm.chapters[i]
            vm.deleteChapter(chapter: entity) { bool in
                if bool {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        vm.getChapter()
    }
}

struct DownloadsChapterView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadsChapterView(entity: MangaEntity())
    }
}
