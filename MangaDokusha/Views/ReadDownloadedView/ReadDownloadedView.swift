//
//  ReadDownloadedView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 14/05/22.
//

import SwiftUI

struct ReadDownloadedView: View {
    @StateObject var vm: ReadDownloadedViewModel

    init(entity: ChapterEntity) {
        _vm = StateObject(wrappedValue: ReadDownloadedViewModel(entity: entity))
    }
    var body: some View {
        ScrollView(showsIndicators: true) {
            ScrollViewReader { value in
                LazyVStack(spacing: 0) {
//                    ForEach(vm.imageUrls, id:\.self) { image in
//                        CustomAsyncImage(url: image)
//                    }
                    ForEach(vm.images, id:\.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
            }
        }
        .onAppear {
            vm.getPages()
        }
        .navigationTitle(vm.pageTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ReadDownloadedView_Previews: PreviewProvider {
    static var previews: some View {
        ReadDownloadedView(entity: ChapterEntity())
    }
}
