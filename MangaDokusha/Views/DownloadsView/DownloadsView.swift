//
//  DownloadsView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 12/05/22.
//

import SwiftUI

struct DownloadsView: View {
    @StateObject var vm = DownloadsViewModel()
    
    @State var isLoading: Bool = false
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.mangas) {
                    manga in
                    NavigationLink {
                        DownloadsChapterView(entity: manga)
                    } label: {
                        MangaListCard(entity: manga)
                    }
                    
                }
                .onDelete { index in
                    delete(index: index)
                }
                
            }
            .isLoading($isLoading)
            .onAppear {
                vm.getManga()
            }
        }
        
    }
    
    func delete(index: IndexSet) {
        for i in index {
            let entity = vm.mangas[i]
            vm.deleteEntity(entity: entity)
        }
        vm.getManga()
//        let entity = vm.chapters[index.count]
//        print(entity)
    }
}

struct DownloadsView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadsView()
    }
}
