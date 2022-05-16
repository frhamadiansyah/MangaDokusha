//
//  TabBarView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 13/04/22.
//

import SwiftUI

struct TabBarView: View {
    @StateObject private var tabController = TabController()
    
    var body: some View {
        TabView(selection: $tabController.activeTab) {
            HomeBaseView()
                .tag(Tab.home)
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
                }
            DownloadsView()
                .tag(Tab.download)
                .tabItem {
                    VStack {
                        Image(systemName: "arrow.down.circle")
                        Text("Downloads")
                    }
                }
        }
        .environmentObject(tabController)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}


enum Tab {
    case home
    case download
}


class TabController: ObservableObject {
    @Published var activeTab = Tab.home
    
    func open(_ tab: Tab) {
        activeTab = tab
    }
}


struct LoadingHandle: ViewModifier {
    @Binding var isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            if isLoading {
                ProgressView("Loading...")
                    .scaleEffect(2)
            }
            content
        }
    }
}
