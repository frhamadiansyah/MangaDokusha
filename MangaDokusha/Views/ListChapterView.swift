//
//  ListChapterView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 08/04/22.
//

import SwiftUI

struct ListChapterView: View {
    
    @ObservedObject var vm: ListChapterViewModel
    
    var body: some View {
        List {
            ForEach(vm.listChapter) { chapter in
                NavigationLink {
                    ReadChapterView(chapter: chapter, mangaDetail: vm.mangaDetail)
                } label: {
                    chapterCard(chapter: chapter.chapter, title: chapter.chapterTitle, group: chapter.scanlation)
                }.onAppear {
                        vm.loadMoreIfNeeded(currentChapter: chapter)
                    }
            }
        }.refreshable {
            vm.loadInitialChapterList()
        }
        .navigationTitle(vm.mangaDetail.title)
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
    
    func chapterCard(chapter: String, title: String, group: String) -> some View {
        HStack {
            VStack {
                Text("\(chapter):")
                    .font(.headline)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("\(title)")
                    .font(.headline)
                Text(group)
                    .font(.subheadline)
            }
        }
    }
}

struct ListChapterView_Previews: PreviewProvider {
    static var previews: some View {
        ListChapterView(vm: ListChapterViewModel(mangaDetail: detailDummy))
    }
}

let detailDummy = MangaDetailModel(id: "1", title: "dd", description: "asd", coverId: "ASDAD")
