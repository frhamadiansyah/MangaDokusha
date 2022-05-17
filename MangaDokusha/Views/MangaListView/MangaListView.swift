//
//  MangaListView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 12/04/22.
//

import SwiftUI

struct MangaListView: View {
    @StateObject var vm: MangaListViewModel = MangaListViewModel()
    
    var body: some View {
        List {
            ForEach(vm.mangaList) { manga in
                Navigator(.content(manga)) {
                    MangaListCard(manga: manga)
                }
                .onAppear {
                    if !vm.searchKeyword.isEmpty {
                        vm.searchMoreIfNeeded(currentManga: manga)
                    }
                }
            }
        }
        .searchable(text: $vm.searchKeyword)
        .isLoading($vm.isLoading)
        
        .handleError(error: vm.error, showError: $vm.showError) { }
    }
    
}

struct MangaListView_Previews: PreviewProvider {
    static var previews: some View {
        MangaListView()
    }
}


//struct MangaListCard: View {
//    let manga: MangaModel
//
//    var body: some View {
//        HStack {
//            if let cover = manga.cover {
//                CustomAsyncImage(url: cover.coverUrl)
//                    .aspectRatio(contentMode: .fit)
//                    .clipped()
//                    .frame(width: 200, height: 200, alignment: .center)
//                    .cornerRadius(5)
//                VStack {
//                    Text(manga.title)
//                        .shadow(radius: 10)
//                }
//                Spacer()
//            }
//        }
//    }
//}