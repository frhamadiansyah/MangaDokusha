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
            SearchView()
                .tag(Tab.search)
                .tabItem {
                    VStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
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
    case search
}


class TabController: ObservableObject {
    @Published var activeTab = Tab.home
    
    func open(_ tab: Tab) {
        activeTab = tab
    }
}
