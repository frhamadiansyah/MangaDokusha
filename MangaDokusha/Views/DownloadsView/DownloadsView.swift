//
//  DownloadsView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 12/05/22.
//

import SwiftUI

struct DownloadsView: View {
    @StateObject var vm = DownloadsViewModel()
    @State private var confirmDelete = false

    var body: some View {
        NavigationView {
            List {
                ForEach(vm.mangas) {
                    manga in
                    
                    Navigator(.offlineListChapter(manga)) {
                        MangaListCard(entity: manga)
                    }
                }
                .onDelete { index in
                    Task {
                        await vm.deleteItems(offsets: index)
                    }

                }
                
            }
            .onAppear {
                Task {
                    await vm.getMangas()
                }
                
            }
            .handleError(error: vm.error, showError: $vm.showError) { }
            .alert(isPresented: $confirmDelete) {
                Alert(
                    title: Text("Are you sure you want to delete all downloads?"),
                    message: Text("There is no undo"),
                    primaryButton: .destructive(Text("Delete")) {
                        vm.deleteAll()
                    },
                    secondaryButton: .cancel()
                )
            }
            .toolbar {
                Button {
                    confirmDelete.toggle()
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Downloads")
        }
        
    }
}

struct DownloadsView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadsView()
    }
}
