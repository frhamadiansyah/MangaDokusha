//
//  LongStripView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 23/05/22.
//

import SwiftUI

struct LongStripView: View {
    @ObservedObject var vm: ReadDownloadedViewModel
    var body: some View {
        ScrollView(showsIndicators: true) {
            ScrollViewReader { value in
                LazyVStack(spacing: 0) {
                    ForEach(vm.images, id:\.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
            }
        }
        
    }
}

struct LongStripView_Previews: PreviewProvider {
    static var previews: some View {
        LongStripView(vm: ReadDownloadedViewModel(entity: ChapterEntity()))
    }
}
