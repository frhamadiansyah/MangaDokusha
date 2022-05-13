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
            //            if let cover = model.cover {
            if let url = vm.coverUrl {
                CustomAsyncImage(url: url)
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .frame(width: 200, height: 200, alignment: .center)
                    .cornerRadius(5)
            }
            if let title = vm.title {
                VStack {
                    Text(title)
                        .shadow(radius: 10)
                }
            }
            
            Spacer()
            //            }
        }
    }
}

struct MangaListCard_Previews: PreviewProvider {
    static var previews: some View {
        MangaListCard(manga: dummyManga)
    }
}
