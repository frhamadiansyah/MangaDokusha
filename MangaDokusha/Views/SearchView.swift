//
//  SearchView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 13/04/22.
//

import SwiftUI

struct SearchView: View {
    @StateObject var vm: SearchViewModel = SearchViewModel()
    @FocusState private var keyboard: Bool

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    HStack {
                        TextField("Search", text: $vm.searchKeyword)
                            .focused($keyboard)
                            .submitLabel(.done)
                            
                        Spacer()
                        Button {
                            vm.searchKeyword = ""
                        } label: {
                            Image(systemName: "x.circle")
                        }

                    }.padding(5)
                        .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.blue, lineWidth: 4)
                            )
                    
                    Button {
                        vm.searchManga()
                        keyboard = false
                    } label: {
                        Image(systemName: "magnifyingglass.circle")
                            .frame(width: 20, height: 20)
                    }

                }
                .padding()
                
                List {
                    ForEach(vm.mangaList) { manga in
                        NavigationLink {
                            ContentView(mangaModel: manga)
                        } label: {
                            MangaListCard(model: manga)
                        }
                        .onAppear {
                            vm.searchMoreIfNeeded(currentManga: manga)
                        }
                    }
                }
                .refreshable {
                    
                }
            }.background {
                errorHandling(error: vm.error, showError: $vm.showError) {
                    
                }
            }
            .onSubmit {
                vm.searchManga()
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
