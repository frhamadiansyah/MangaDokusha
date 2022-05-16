//
//  Navigator.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 16/05/22.
//

import Foundation
import SwiftUI
import CoreData


enum Route {
    case content(MangaModel)
    case listChapter(MangaModel)
    case onlineReading(MangaModel?, ChapterModel)
    case offlineListChapter(MangaEntity)
    case offlineReading(ChapterEntity)
}


struct Navigator<Content: View>: View {
    let content: Content
    let route: Route

    init(_ route: Route, @ViewBuilder content: () -> Content) {
        self.route = route
        self.content = content()
    }

    var body: some View {
        switch route {
        case .content(let mangaModel):
            NavigationLink {
                BaseView {
                    ContentView(mangaModel: mangaModel)
                }
            } label: {
                content
            }

        case .listChapter(let mangaModel):
            NavigationLink {
                BaseView {
                    ListChapterView(manga: mangaModel)
                }
            } label: {
                content
            }
        case .onlineReading(let manga, let chapter):
            NavigationLink {
                BaseView {
                    ReadingView(vm: ReadChapterViewModel(manga: manga, chapter: chapter))
                }
            } label: {
                content
            }

        case .offlineListChapter(let mangaEntity):
            NavigationLink {
                BaseView {
                    DownloadsChapterView(entity: mangaEntity)
                }
            } label: {
                content
            }

        case .offlineReading(let chapterEntity):
            NavigationLink {
                BaseView {
                    ReadDownloadedView(entity: chapterEntity)
                }
            } label: {
                content
            }
        }
        

    }
}
