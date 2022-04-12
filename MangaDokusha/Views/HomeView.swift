//
//  HomeView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 12/04/22.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            MangaListView()
            .navigationTitle("Home")
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
