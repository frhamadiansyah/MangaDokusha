//
//  ContentView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 06/04/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm: ContentViewModel
    
    init(mangaId: String) {
        self.vm = ContentViewModel(mangaId: mangaId)
    }
    
    init(mangaModel: MangaDetailModel) {
        self.vm = ContentViewModel(mangaId: mangaModel.id)
        self.vm.mangaDetail = mangaModel
    }
    
//    let state
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                if let detail = vm.mangaDetail {

                    customAsyncImage(url: detail.coverUrl ?? "NIL")
                        .frame(width: 200, height: 400, alignment: .center)
                        .cornerRadius(5)

                    authorAndArtistView(author: detail.author ?? "", authorId: detail.authorId ?? "", artist: detail.artist ?? "", artistId: detail.artistId ?? "")
//                    authorAndArtistView(author: detail.author ?? "NIL", artist: detail.artist ?? "NIL")
                    Text("rating: \(detail.contentRating.rawValue)")
                        .padding(5)
                    
                    Text("status: \(detail.status)")
                        .padding(5)
                    goToListChapterView(mangaDetail: detail)
                    
                    Text(detail.description)
                        .font(.body)

                } else {
                    ProgressView()
                }

     
            }.padding(.horizontal)
                .navigationTitle(vm.mangaDetail?.title ?? "Manga")
        }
        .onAppear {
            vm.getDetailManga(mangaId: vm.mangaId)
        }
        .background {
            errorHandling(error: vm.error, showError: $vm.showError)
            {

            }
        }
    }
    
    func authorAndArtistView(author: String, authorId: String, artist: String, artistId: String) -> some View {
        HStack {
            VStack {
                Text("Author")
                    .font(.headline)
                NavigationLink {
                    MangaListView(vm: MangaListViewModel(authorId: authorId))
                } label: {
                    Text(author)
                        .font(.subheadline)
                }

            }
            .padding(.horizontal)
            Spacer()
            VStack {
                Text("Artist")
                    .font(.headline)
                NavigationLink {
                    MangaListView(vm: MangaListViewModel(artistId: artistId))
                } label: {
                    Text(artist)
                        .font(.subheadline)
                }

            }
            .padding(.horizontal)
        }.padding()
    }
    
    
    func goToListChapterView(mangaDetail: MangaDetailModel) -> some View {
        NavigationLink {
            ListChapterView(vm: ListChapterViewModel(mangaDetail: mangaDetail))
        } label: {
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
