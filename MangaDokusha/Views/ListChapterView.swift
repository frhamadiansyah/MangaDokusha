//
//  ListChapterView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 08/04/22.
//

import SwiftUI

struct ListChapterView: View {
    
    @ObservedObject var vm: ListChapterViewModel
    @State var readChapter: Bool = false
    @State var selectedChapter: ChapterModel = ChapterModel()
    
    var body: some View {
        List {
            ForEach(vm.listChapter) { chapter in
                Button(action: {
                    vm.selectedChapter = chapter
                    
                    readChapter.toggle()
                }, label: {
                    ChapterCard(chapter: chapter)
                })
                .onAppear {
                        vm.loadMoreIfNeeded(currentChapter: chapter)
                    }
                .fullScreenCover(isPresented: $readChapter) {
                    ReadingView(vm: vm.readingVm)

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
        .background {
            errorHandling(error: vm.error, showError: $vm.showError) {
                
            }
        }
        .onAppear {
            vm.loadInitialChapterList()
        }
    }
    

}

struct ListChapterView_Previews: PreviewProvider {
    static var previews: some View {
        ListChapterView(vm: ListChapterViewModel(manga: MangaModel()))
    }
}

