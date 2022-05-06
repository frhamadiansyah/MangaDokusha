//
//  ReadingView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 06/05/22.
//

import SwiftUI

struct ReadingView: View {
    @ObservedObject var vm: ReadChapterViewModel
    @Environment(\.presentationMode) var presentationMode
    
//    init(manga: MangaModel, chapter: ChapterModel) {
//        vm = ReadChapterViewModel()
//        vm.currentChapter = chapter
//        vm.manga = manga
//    }
    init(vm: ReadChapterViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            ScrollViewReader { value in
                VStack(spacing: 0) {
//                    Text("\(vm.currentChapter?.title)")
//
//                    Text("\(vm.manga?.title)")
                    
                    
                    ForEach(vm.imageUrls, id:\.self) { image in
                        customAsyncImage(url: image)
                    }
                    
                }
            }
        }.onAppear(perform: {
            let req = vm.getChapterImageRequest()
            vm.loadChapterImageUrl(request: req)
        })
        .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .local)
            .onEnded({ value in
                if value.translation.width > 0 {
                    print("QUIT")
                    self.presentationMode.wrappedValue.dismiss()
                                            // left
                                        }
                else {
                    print("SWIPER!!!")
                }

            })
        )
        
    }
}

struct ReadingView_Previews: PreviewProvider {
    static var previews: some View {
//        ReadingView()
        Text("MALES")
    }
}
