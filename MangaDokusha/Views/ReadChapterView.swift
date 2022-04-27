//
//  ReadChapterView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 08/04/22.
//

import SwiftUI

struct ReadChapterView: View {
    
    @Namespace var topID
    @Namespace var bottomID
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm: ReadChapterViewModel
    var title: String
    
    init(chapter: ChapterTitleModel, mangaDetail: MangaDetailModel) {
        self.vm = ReadChapterViewModel(chapter: chapter, mangaDetail: mangaDetail)
        self.title = chapter.chapterTitle
    }
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            ScrollViewReader { value in
                VStack(spacing: 0) {
                    Text("\(vm.currentChapter.chapterTitle)")
                        .id(topID)
                    Text("\(vm.currentChapter.mangaTitle)")
                    
                    changeChapter(value: value)
                    
                    ForEach(vm.imageUrl, id:\.self) { image in
                        customAsyncImage(url: image)      
                    }
                    changeChapter(value: value)
                }
            }
        }.onAppear(perform: {
            vm.loadChapterImageUrl(chapterId: vm.chapterId)
        })
        .background {
            errorHandling(error: vm.error, showError: $vm.showError)
            {
                self.vm.error = nil
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle("Chapter \(vm.currentChapter.chapter)")
        .navigationBarTitleDisplayMode(.inline)
    }

    
    func changeChapter(value : ScrollViewProxy) -> some View {
        HStack {
            Button {
                print("Prev")
                vm.goToPrevioustChapter()
            } label: {
                Text("Back")
                    .padding(.horizontal, 30)
            }
            Spacer()
            Button {
                print("NEXT")
                vm.goToNextChapter()
                value.scrollTo(topID)
            } label: {
                Text("Next")
                    .padding(.horizontal, 30)
            }
        }.padding()
    }
    

}

struct ReadChapterView_Previews: PreviewProvider {
    static var previews: some View {
        ReadChapterView(chapter: dummyChapterTitleModel, mangaDetail: dummyMangaDetail)
    }
}

let dummyChapterTitleModel = ChapterTitleModel(id: "", mangaId: "", mangaTitle: "", scanlation: "", chapter: "", chapterTitle: "")

let dummyMangaDetail = MangaDetailModel(id: "", title: "", description: "", coverId: nil)
