//
//  ChapterCard.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 26/04/22.
//

import SwiftUI

struct ChapterCard: View {
    let chapter: ChapterTitleModel
    var body: some View {
        HStack {
            VStack {
                Text("\(chapter.chapter):")
                    .font(.headline)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("\(chapter.chapterTitle)")
                    .font(.headline)
                Spacer()
                Text(chapter.scanlation)
                    .font(.subheadline)
                    .padding(.bottom, 5)
            }
            
            Spacer()
            
            Button {
                print("\(chapter.chapter) downloaded")
            } label: {
                Image(systemName: "arrow.down.circle")
                    .padding(10)
            }.buttonStyle(PlainButtonStyle())

        }
    }
}

struct ChapterCard_Previews: PreviewProvider {
    static var previews: some View {
        ChapterCard(chapter: dummyChapterTitleModel)
    }
}
