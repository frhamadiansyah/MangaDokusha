//
//  ListChapterView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 08/04/22.
//

import SwiftUI

struct ListChapterView: View {
    
    @StateObject var vm: ListChapterViewModel
    @State var readChapter: Bool = false
    
    init(manga: MangaModel) {
        _vm = StateObject(wrappedValue: ListChapterViewModel(manga: manga))
    }
    
    var body: some View {
        List {
            ForEach(vm.listChapter) { chapter in
                NavigationLink(destination: {
                    BaseView {
                        ReadingView(vm: ReadChapterViewModel(manga: vm.currentManga, chapter: chapter))
                    }
                }, label: {
                    ChapterCard(manga: vm.currentManga, chapter: chapter)
                })
                .onAppear {
                    vm.loadMoreIfNeeded(currentChapter: chapter)
                }
            }
        }.refreshable {
            vm.loadInitialChapterList()
        }
        .navigationTitle(vm.currentManga?.title ?? "")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    print("Ascend Descend")
                    vm.isAscending.toggle()
                    vm.listChapter = []
                    vm.loadInitialChapterList()
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                }
            }
        }
        .handleError(error: vm.error, showError: $vm.showError) { }
        .onAppear {
            if vm.listChapter.isEmpty {
                vm.loadInitialChapterList()
            }
        }
    }
}

struct ListChapterView_Previews: PreviewProvider {
    static var previews: some View {
        ListChapterView(manga: MangaModel())
    }
}

