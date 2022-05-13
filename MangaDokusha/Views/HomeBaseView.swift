//
//  HomeBaseView.swift
//  MangaDokusha
//
//  Created by Fandrian Rhamadiansyah on 08/04/22.
//

import SwiftUI

struct HomeBaseView: View {
    var body: some View {
        NavigationView {
            BaseView {
                MangaListView()
            }
            .navigationTitle("Home")
        }
    }
}

struct HomeBaseView_Previews: PreviewProvider {
    static var previews: some View {
        HomeBaseView()
    }
}


let mangaIds = [
    "b73371d4-02dd-4db0-b448-d9afa3d698f1",
    "b5b21ca1-bba5-4b9a-8cd1-6248f731650b",
    "8847f905-550d-4fe6-bcda-ac2b896789c7",
    "4141c5dc-c525-4df5-afd7-cc7d192a832f",
    "32d76d19-8a05-4db0-9fc2-e0b0648fe9d0"
]
