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
            Section {
                ForEach(vm.chapters) { chapter in
                    Navigator(.offlineReading(chapter)) {
                        Label {
                            Text("\(chapter.chapterTitle ?? "")")
                        } icon: {
                            Text("\(chapter.chapter.toString()) :")
                        }
                    }
                }
                .onDelete { index in
                    Task {
                        await vm.deleteItems(offsets:index)
                    }
                }
            }
            Section {
                Navigator(.listChapter(MangaModel(id: vm.entity.id ?? "", title: "", description: ""))) {
                    Text("See All Chapters")
                }

            }
            
        }
        .handleError(error: vm.error, showError: $vm.showError) {
            self.presentationMode.wrappedValue.dismiss()
        }
        .task {
            await vm.getChapters()
        }
        .navigationTitle(vm.mangaTitle)

    }

}

struct DownloadsChapterView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadsChapterView(entity: MangaEntity())
    }
}
