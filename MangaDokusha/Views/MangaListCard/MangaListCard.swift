//
//  MangaListCard.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 13/05/22.
//

import SwiftUI

struct MangaListCard: View {
    @StateObject var vm: MangaCardViewModel
    
    init(manga: MangaModel?) {
        _vm = StateObject(wrappedValue: MangaCardViewModel(manga: manga))
    }
    
    init(entity: MangaEntity?) {
        _vm = StateObject(wrappedValue: MangaCardViewModel(entity: entity))
    }
    
    var body: some View {
        HStack {
            if let url = vm.coverUrl {
                CustomAsyncImage(url: url)
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .frame(width: 200, height: 200, alignment: .center)
                    .cornerRadius(5)
            }
            VStack(alignment: .leading) {
                if let title = vm.title {
                    Text(title)
                        .font(.title2)
                        .shadow(radius: 10)
                    
                }
                if let chapterCount = vm.entity?.chapters?.count {
                    if chapterCount <= 1 {
                        Text("\(chapterCount) downloaded chapter")
                            .font(.footnote)
                    } else {
                        Text("\(chapterCount) downloaded chapters")
                            .font(.footnote)
                    }
                    
                }
                
            }
            
            Spacer()
        }
    }
}

struct MangaListCard_Previews: PreviewProvider {
    static var previews: some View {
        MangaListCard(manga: dummyManga)
    }
}
