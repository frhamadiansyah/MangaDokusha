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
            //            VStack {
            ForEach(vm.mangaList) { manga in
                NavigationLink {
                    ContentView(mangaModel: manga)
                } label: {
                    MangaListCard(model: manga)
                }
            }
            //                Text("ASD")
            //            }
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
        HStack {
            customAsyncImage(url: model.coverUrl ?? "")
//                .aspectRatio(contentMode: .fill)
                .clipped()
                .frame(width: 200, height: 200, alignment: .center)
                .cornerRadius(5)
            VStack {
//                Spacer()
                Text(model.title)
                    .shadow(radius: 10)
            }
            Spacer()
        }
//        .frame(width: 400, height: 200, alignment: .top)
//        .clipped()
//        .cornerRadius(5)
        
//        .padding()
    }
}