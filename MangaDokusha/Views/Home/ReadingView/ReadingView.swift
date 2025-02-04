//
//  ReadingView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 06/05/22.
//

import SwiftUI
import SwiftUIIntrospect
import Zoomable

struct ReadingView: View {
    @ObservedObject var vm: ReadChapterViewModel
    @State var uiTabarController: UITabBarController?
//    @Environment(\.presentationMode) var presentationMode
    
    init(vm: ReadChapterViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            ScrollViewReader { value in
                LazyVStack(spacing: 0) {
                    ForEach(vm.imageUrls, id:\.self) { image in
                        CustomAsyncImage(url: image).zoomable()
                    }
                }
            }
        }
        .handleError(error: vm.error, showError: $vm.showError) { }
        .navigationTitle("Chapter \(vm.currentChapter?.chapter.toString() ?? "0")")
        .navigationBarTitleDisplayMode(.inline)
        .introspect(.tabView, on: .iOS(.v18), customize: { tabview in
            tabview.tabBar.isHidden = true
            uiTabarController = tabview
        })
        .onDisappear{
            uiTabarController?.tabBar.isHidden = false
        }
        .onAppear(perform: {
            let req = vm.getChapterImageRequest()
            vm.loadChapterImageUrl(request: req)
        })
        
    }
}

struct ReadingView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingView(vm: ReadChapterViewModel())
    }
}
