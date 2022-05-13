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
                    MangaListCard(entity: manga)
                }
//                Text("Hello, World!")
//                Spacer()
//                Button("LOADING") {
//                    isLoading.toggle()
//                }

                
            }
            .isLoading($isLoading)
            .onAppear {
                vm.getManga()
            }
        }
        
    }
}

struct DownloadsView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadsView()
    }
}
