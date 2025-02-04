//
//  LandscapeView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 23/05/22.
//

import SwiftUI

struct LandscapeView: View {
    @ObservedObject var vm: ReadDownloadedViewModel
    
    @State private var pages = [UIImage]()
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            //if usual
            if pages.count == 2 {
                Image(uiImage: pages[1])
                    .resizable()
                    .scaledToFit()
                Image(uiImage: pages[0])
                    .resizable()
                    .scaledToFit()
            } else if pages.count == 1 {
                Image(uiImage: pages[0])
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "photo")
            }
            
        }
        .onAppear {
            pages = vm.distributeNextPage()
        }
        .gesture(DragGesture()
            .onEnded({ value in
                if value.translation.width > 0 {
                    vm.count -= 1
                    let newPages = vm.distributePreviousPage(currentPages: pages)
                    pages = newPages
                } else {
                    vm.count += 1
                    pages = vm.distributeNextPage()
                }
            })
        )
        
        
    }
    
    
}

struct LandscapeView_Previews: PreviewProvider {
    static var previews: some View {
        LandscapeView(vm: ReadDownloadedViewModel(entity: ChapterEntity()))
    }
}
