//
//  MangaListView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 12/04/22.
//

import SwiftUI

struct MangaListView: View {
    @StateObject var vm: HomeViewModel = HomeViewModel()
    var body: some View {
        List {
            LazyVStack {
                ForEach(vm.mangaList) { manga in
                    NavigationLink {
                        ContentView(mangaId: manga.id)
                    } label: {
                        MangaListCard(model: manga)
                    }
                }
                Text("ASD")
            }
        }.refreshable {
            print("REFRESH")
        }
        .background {
            errorHandling(error: vm.error, showError: $vm.showError) {
                
            }
        }
    }
}

struct MangaListView_Previews: PreviewProvider {
    static var previews: some View {
        MangaListView()
    }
}


struct MangaListCard: View {
    let model: MangaDetailModel
    
    var body: some View {
        Text("TITLE")
    }
}
