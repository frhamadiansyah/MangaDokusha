//
//  ContentView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 06/04/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm: ContentViewModel
    
    init(mangaId: String) {
        _vm = StateObject(wrappedValue: ContentViewModel(mangaId: mangaId))
    }
    
    init(mangaModel: MangaModel) {
        _vm = StateObject(wrappedValue: ContentViewModel(manga: mangaModel))
    }
    
//    let state
    var body: some View {
        ScrollView {
            if let detail = vm.mangaModel,
               let cover = vm.mangaModel?.cover,
               let author = vm.mangaModel?.author,
               let artist = vm.mangaModel?.artist {
                VStack(spacing: 10) {

                    CustomAsyncImage(url: cover.coverUrl)
                        .frame(width: 200, height: 400, alignment: .center)
                        .cornerRadius(5)

                    authorAndArtistView(author: author, artist: artist)
                    
                    goToListChapterView(mangaDetail: detail)

                    TagsView(title: "Content Rating", tags: [detail.contentRating.rawValue], color: detail.contentRating.getColor())
                    
                    TagsView(title: "Tags", tags: detail.tags)
                    
                    TagsView(title: "Status", tags: [detail.status.rawValue], color: detail.status.getColor())
                    
                        
                    Text(detail.description)
                        .font(.body)

         
                }.padding(.horizontal)
                    .navigationTitle(detail.title)
            }

        }
        .handleError(error: vm.error, showError: $vm.showError) { }
        .onAppear {
            let urlReq = vm.getDetailMangaRequest(mangaId: vm.mangaId)
            vm.getDetailManga(urlRequest: urlReq)
        }
    }
    
    func authorAndArtistView(author: CreatorModel, artist: CreatorModel) -> some View {
        HStack {
            VStack {
                Text("Author")
                    .font(.headline)
                NavigationLink {
                    BaseView {
                        MangaListView(vm: MangaListViewModel(creator: author))
                    }
                } label: {
                    Text(author.name)
                        .font(.subheadline)
                }

            }
            .padding(.horizontal)
            Spacer()
            VStack {
                Text("Artist")
                    .font(.headline)
                NavigationLink {
                    BaseView {
                        MangaListView(vm: MangaListViewModel(creator: artist))
                    }
                } label: {
                    Text(artist.name)
                        .font(.subheadline)
                }

            }
            .padding(.horizontal)
        }.padding()
    }
    
    
    func goToListChapterView(mangaDetail: MangaModel) -> some View {
        Navigator(.listChapter(mangaDetail)) {
            HStack {
                Text("Chapter List")
                    .font(.title3)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding()
            .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue, lineWidth: 4)
                )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(mangaId: "801513ba-a712-498c-8f57-cae55b38cc92")
    }
}
