//
//  MangaListView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 12/04/22.
//

import SwiftUI

struct MangaListView: View {
    @StateObject var vm: MangaListViewModel = MangaListViewModel()
    @State private var didAppear: Bool = false
    
    init() {
        print("CALLED ONCE")
    }
    var body: some View {
        List {
            ForEach(vm.mangaList) { manga in
                NavigationLink {
                    BaseView {
                        ContentView(mangaModel: manga)
                    }
                } label: {
                    MangaListCard(model: manga)
                }
            }
        }
        .onAppear(perform: onLoad)
//        .searchable(text: $vm.searchKeyword)
        .background {
            errorHandling(error: vm.error, showError: $vm.showError) { }
        }
    }
    
    func onLoad() {
        if !didAppear {
            if vm.mangaList.isEmpty {
                let req = vm.getMangaListRequest(id: mangaIds)
                print(mangaIds.count)
                vm.getMangaList(request: req)
            }
        }
        didAppear = true
    }
}

struct MangaListView_Previews: PreviewProvider {
    static var previews: some View {
        MangaListView()
    }
}


struct MangaListCard: View {
    let model: MangaModel
    
    var body: some View {
        HStack {
            if let cover = model.cover {
                customAsyncImage(url: cover.coverUrl)
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .frame(width: 200, height: 200, alignment: .center)
                    .cornerRadius(5)
                VStack {
                    Text(model.title)
                        .shadow(radius: 10)
                }
                Spacer()
            }
        }
    }
}
