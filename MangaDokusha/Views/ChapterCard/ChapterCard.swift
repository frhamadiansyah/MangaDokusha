//
//  ChapterCard.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 26/04/22.
//

import SwiftUI

struct ChapterCard: View {
    @StateObject var vm : ChapterViewModel

    init(manga: MangaModel?, chapter: ChapterModel) {
        _vm = StateObject(wrappedValue: ChapterViewModel(manga: manga, chapter: chapter))
    }
    var body: some View {
        HStack {
            VStack {
                Text("\(vm.chapter.chapter):")
                    .font(.headline)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("\(vm.chapter.title)")
                    .font(.headline)
                Spacer()
                Text(vm.chapter.group)
                    .font(.subheadline)
                    .padding(.bottom, 5)
            }
            
            Spacer()
            
            Button {
                vm.downloadChapter()
                print("\(vm.chapter.chapter) downloaded!!!")
            } label: {
                if vm.isDownloaded {
                    Image(systemName: "arrow.down.circle.fill")
                        .padding(10)
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "arrow.down.circle")
                        .padding(10)
                }
                
            }
            .disabled(vm.isDownloaded)
            .buttonStyle(PlainButtonStyle())

        }
        .onAppear {
            vm.checkIfDownloaded()
        }
    }
}

struct ChapterCard_Previews: PreviewProvider {
    static var previews: some View {
        ChapterCard(manga: dummyManga, chapter: dummyChapter)
    }
}