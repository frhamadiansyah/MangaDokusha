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


